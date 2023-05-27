import json, sys, os, re

from config import dtHttpPath

dir_path = os.path.dirname(os.path.realpath(__file__))

sourcePath = os.path.join(dir_path, dtHttpPath, "build/generated", "swagger.json")
targetPath = os.path.join(dir_path, "../generated")

if not os.path.exists(sourcePath):
    sys.exit(f'Source path /"{sourcePath}/" not found')

sourceFile = open(sourcePath)
sourceJson = json.load(sourceFile)

types = {}
options = {}

def sanitizeTitle(name):
    if len(name) == 0: return ""
    return name[0].upper() + name[1:]

def sanitizeName(name):
    if len(name) == 0: return ""
    return name[0].lower() + name[1:]

def sanitizeDesc(desc):
    return desc.replace('\n', ' ').replace('\r', '')

# Check whether property is an array
def propertyIsArray(property):
    
    type = property['type'] if 'type' in property else "string"
    return type == "array"

# Convert property object to type name
def propertyToTypeName(property):

    if '$ref' in property:
        ref = property['$ref']
        return types[ref] if ref in types else 'String'
    
    type = property['type'] if 'type' in property else "string"
    format = property['format'] if 'format' in property else ""

    if type == "string":
        if format == "date-time":
            return 'String'
        if format == "byte":
            return 'PackedByteArray'
        if format == "binary":
            return 'PackedByteArray'
        return 'String'

    elif type == "number":
        # We don't differentiate between float/double format
        return 'float'

    elif type == "integer":
        if format == "int32":
            return 'int'
        if format == "int64":
            return 'int'
        return 'int'

    elif type == "boolean":
        return 'bool'
    
    elif type == "array":
        subType = propertyToTypeName(property['items'])
        return f'Array[{subType}]'
    
    return 'string'

# Convert property object to description
def propertyToOptions(property):

    description = property['description'] if 'description' in property else ""

    if '$ref' in property:
        ref = property['$ref']
        if ref in options:
            (otherTypeName, otherDescription, otherOption) = options[ref]
            description = description if description else otherDescription
            return (otherTypeName, description, otherOption)
        else:
            return (propertyToTypeName(property), description, "None")

    if propertyIsArray(property):
        (otherTypeName, otherDescription, otherOption) = propertyToOptions(property['items'])
        description = description if description else otherDescription
        return (propertyToTypeName(property), description, otherOption)
    
    return (propertyToTypeName(property), description, "")

# Detect models
for schemaName, schema in sourceJson['components']['schemas'].items():

    description = sanitizeDesc(schema['description'] if 'description' in schema else "")
    schemaPath = f'#/components/schemas/{schemaName}'

    if 'enum' in schema:

        enumType = f'int'
        if schema['type'] == 'string':
            enumType = f'String'
        types[schemaPath] = enumType
        options[schemaPath] = (enumType, description, ", ".join([str(name) for name in schema['enum']]))

    elif schema['type'] == 'object':
        objectType = f'Dictionary'
        types[schemaPath] = objectType
        options[schemaPath] = (objectType, description, [(propertyName, propertyToOptions(property))
                                for propertyName, property in schema['properties'].items()])
        
    elif not schemaPath in types:
        typeName = propertyToTypeName(schema)
        types[schemaPath] = typeName
        options[schemaPath] = (typeName, description, "")

print(f'Detected Models')

# Print api
apiData = f'''
class_name DTAPI
extends DTRequester
'''

def writeOptions(options, indent = 0):
    output = ""
    if isinstance(options, list): 
        for name, option in options:
            (type, decription, children) = option
            output += "\n##\t%s%s: %s" % (indent * '\t', name, type)
            if decription:
                output += " // %s" % (decription)
            output += writeOptions(children, indent + 1)
    return output

for pathName, path in sourceJson['paths'].items():

    for operationName, operation in path.items():

        sanitizedPath = "".join([sanitizeTitle(s) for s in pathName.split('/')])
        functionName = sanitizeName(re.sub(r'{[a-zA-Z]*}', "With", sanitizeTitle(operationName) + sanitizedPath))
        
        operationDesc = sanitizeDesc(operation['description'] if 'description' in operation else "")

        functionOptions = []
        
        functionParams = []
        functionParamArgs = []
        functionParamQueries = []
        functionParamPath = []
        for parameter in operation['parameters']:

            if parameter['in'] == 'path':

                parameterType = propertyToTypeName(parameter['schema'])
                parameterName = parameter['name']

                functionOptions.append((parameterName, propertyToOptions(parameter['schema'])))
                functionParams.append(f'{sanitizeName(parameterName)}:{parameterType}')
                functionParamArgs.append(f'"{parameterName}": str({sanitizeName(parameterName)})')
                
            if parameter['in'] == 'query':

                parameterType = propertyToTypeName(parameter['schema'])
                parameterName = parameter['name']

                functionOptions.append((parameterName, propertyToOptions(parameter['schema'])))
                functionParams.append(f'{sanitizeName(parameterName)}:{parameterType}')
                functionParamQueries.append(f'"{parameterName}": str({sanitizeName(parameterName)})')
        
        if 'requestBody' in operation:
            functionOptions.append(('body', propertyToOptions(operation['requestBody']['content']['application/json']['schema'])))
        
        if '200' in operation['responses'] and 'content' in operation['responses']['200']:
            functionOptions.append(('return', propertyToOptions(operation['responses']['200']['content']['application/json']['schema'])))
        
        httpVerb = operationName.upper()
        httpPath = f'{pathName}{functionParamPath}'

        functionParamArgsString = ",\n\t\t".join(functionParamArgs)
        functionParamQueriesString = ",\n\t\t".join(functionParamQueries)

        hasBody = httpVerb == "POST" or httpVerb == "PUT"

        apiParams = functionParams
        if hasBody:
            apiParams.append("body: Dictionary")
        apiParams.append("onSuccess: Callable")
        apiParams.append("onError: Callable")
        functionParamString = ", ".join(apiParams)

        apiData += f'''
## {operationDesc}{writeOptions(functionOptions)}
func {functionName}({functionParamString}):
    var params = {{{functionParamArgsString}}}
    var queries = {{{functionParamQueriesString}}}
    return request{httpVerb.capitalize()}("{pathName}", params, queries{", body" if hasBody else ""}, onSuccess, onError)
'''

apiTargetPath = os.path.join(targetPath, "dt_api.gd")
f = open(apiTargetPath, "w")
f.write(apiData)
f.close()

print(f'Generated API to {apiTargetPath}')
