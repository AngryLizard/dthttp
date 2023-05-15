import json
import sys
import os 

from config import getPropCType, dtHttpPath

dir_path = os.path.dirname(os.path.realpath(__file__))

sourcePath = os.path.join(dir_path, dtHttpPath, "build/generated", "properties.json")
targetPath = os.path.join(dir_path, "../Source/DTHttpClient/Public/Generated")

if not os.path.exists(sourcePath):
    sys.exit(f'Source path /"{sourcePath}/" not found')

sourceFile = open(sourcePath)
sourceJson = json.load(sourceFile)

def sanitizeName(name):
    if len(name) == 0: return ""
    return name[0].upper() + name[1:]

# Print properties
propertiesData = f'''
#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "DTProperties.generated.h"
'''

propertiesData += f'''
UENUM(BlueprintType)
enum class EDTPropertyType : uint8
{{'''
for prop in sourceJson:
    propertiesData += f'''
    /** {prop['desc']} */
    {prop['propType']},'''
propertiesData += f'''
    Any
}};

FORCEINLINE FString LexToString(EDTPropertyType Value)
{{
    switch (Value)
    {{'''
for prop in sourceJson:
    propertiesData += f'''
    case EDTPropertyType::{prop['propType']}: return TEXT("{prop['propType']}");'''
propertiesData += f'''
    default: return TEXT("");
    }}
}};

FORCEINLINE void LexFromString(EDTPropertyType& Value, const TCHAR* Buffer)
{{
    FString Name = FString(Buffer);'''
for prop in sourceJson:
    propertiesData += f'''
    if (Name.Equals(TEXT("{prop['propType']}"))) Value = EDTPropertyType::{prop['propType']}; else'''
propertiesData += f'''
    {{ Value = EDTPropertyType::Any; }}
}};
'''

propertiesTargetPath = os.path.join(targetPath, "DTProperties.h")
f = open(propertiesTargetPath, "w")
f.write(propertiesData)
f.close()

print(f'Generated Properties to {propertiesTargetPath}')

# Print conversion library
conversionsData = f'''
#pragma once

#include "CoreMinimal.h"
#include "Game/DTGameProperties.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "DTConversions.generated.h"
'''

conversionsData += f'''
UCLASS()
class DTHTTPCLIENT_API UDTGamePropertyLibrary : public UBlueprintFunctionLibrary
{{
	GENERATED_BODY()
'''
for prop in sourceJson:
    cTypeParam = getPropCType(prop['propType'], True)
    conversionsData += f'''
	UFUNCTION(BlueprintPure, meta = (DisplayName = "To PropertyValue ({prop['propType']})", CompactNodeTitle = "->", Keywords = "cast convert", BlueprintAutocast))
		static FSerialPropertyValue Conv_{prop['propType']}ToPropertyValue({cTypeParam} Value)
        {{
            FSerialPropertyValue Param;
            Param.Type = EDTPropertyType::{prop['propType']};
            Param.Value = LexToString(Value);
            return Param;
        }}
'''
conversionsData += f'''
}};
'''

conversionsTargetPath = os.path.join(targetPath, "DTConversions.h")
f = open(conversionsTargetPath, "w")
f.write(conversionsData)
f.close()

print(f'Generated Conversions to {conversionsTargetPath}')
