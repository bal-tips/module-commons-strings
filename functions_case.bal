// Copyright (c) 2025 Hasitha Aravinda. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ballerina/lang.regexp;

# Helper function to trim specific characters from start and end of string
#
# + str - The string to trim
# + char - The character to trim
# + return - The trimmed string
isolated function trimChar(string str, string char) returns string {
    string result = str;
    
    // Trim from start
    while result.startsWith(char) && result.length() > 0 {
        result = result.substring(1);
    }
    
    // Trim from end
    while result.endsWith(char) && result.length() > 0 {
        result = result.substring(0, result.length() - 1);
    }
    
    return result;
}

# Converts a string from snake_case, kebab-case, or "Sentence case" to camelCase.
#
# + str - The string to convert
# + return - The camelCase string
public isolated function toCamelCase(string str) returns string {
    if str.length() == 0 {
        return str;
    }
    
    // Split by common separators
    string[] parts = regexp:split(re `[\s_-]+`, str);
    string result = "";
    
    foreach int i in 0..<parts.length() {
        string part = parts[i].trim().toLowerAscii();
        if part.length() > 0 {
            if i == 0 {
                result += part;
            } else {
                result += part.substring(0, 1).toUpperAscii() + part.substring(1);
            }
        }
    }
    
    return result;
}

# Converts a string from camelCase or kebab-case to snake_case.
#
# + str - The string to convert
# + return - The snake_case string
public isolated function toSnakeCase(string str) returns string {
    if str.length() == 0 {
        return str;
    }
    
    string result = "";
    foreach int i in 0..<str.length() {
        string char = str.substring(i, i + 1);
        if char >= "A" && char <= "Z" {
            if i > 0 {
                result += "_";
            }
            result += char.toLowerAscii();
        } else if char == "-" || char == " " {
            result += "_";
        } else {
            result += char;
        }
    }
    
    // Clean up multiple underscores and convert to lowercase
    result = regexp:replaceAll(re `_+`, result, "_");
    result = trimChar(result, "_");
    
    return result;
}

# Converts a string from camelCase or snake_case to kebab-case.
#
# + str - The string to convert
# + return - The kebab-case string
public isolated function toKebabCase(string str) returns string {
    if str.length() == 0 {
        return str;
    }
    
    string result = "";
    foreach int i in 0..<str.length() {
        string char = str.substring(i, i + 1);
        if char >= "A" && char <= "Z" {
            if i > 0 {
                result += "-";
            }
            result += char.toLowerAscii();
        } else if char == "_" || char == " " {
            result += "-";
        } else {
            result += char;
        }
    }
    
    // Clean up multiple hyphens
    result = regexp:replaceAll(re `-+`, result, "-");
    result = trimChar(result, "-");
    
    return result;
}

# Capitalizes the first letter of every word.
#
# + str - The string to convert
# + return - The Title Case string
public isolated function toTitleCase(string str) returns string {
    if str.length() == 0 {
        return str;
    }
    
    // Split by whitespace while preserving separators
    string[] words = regexp:split(re `\s+`, str);
    string result = "";
    
    foreach int i in 0..<words.length() {
        if i > 0 {
            result += " ";
        }
        string word = words[i];
        if word.length() > 0 {
            result += word.substring(0, 1).toUpperAscii() + word.substring(1).toLowerAscii();
        }
    }
    
    return result;
}

# Converts a string to uppercase.
#
# + str - The string to convert
# + return - The UPPERCASE string
public isolated function toUpperCase(string str) returns string {
    return str.toUpperAscii();
}

# Converts a string to lowercase.
#
# + str - The string to convert
# + return - The lowercase string
public isolated function toLowerCase(string str) returns string {
    return str.toLowerAscii();
}
