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

# A powerful combination that trims leading/trailing whitespace and collapses multiple internal spaces into one.
#
# + str - The string to clean
# + return - The cleaned string
public isolated function trimAndClean(string str) returns string {
    if str.length() == 0 {
        return str;
    }
    
    // First trim whitespace
    string result = str.trim();
    
    // Collapse multiple whitespace characters into single space
    result = regexp:replaceAll(re `\s+`, result, " ");
    
    return result;
}

# Strips all characters that are not digits (0-9).
#
# + str - The string to process
# + return - String containing only numeric characters
public isolated function removeNonNumeric(string str) returns string {
    return regexp:replaceAll(re `[^0-9]`, str, "");
}

# Strips all characters that are not alphabetic.
#
# + str - The string to process
# + return - String containing only alphabetic characters
public isolated function removeNonAlpha(string str) returns string {
    return regexp:replaceAll(re `[^a-zA-Z]`, str, "");
}

# Strips all characters that are not alphanumeric.
#
# + str - The string to process
# + return - String containing only alphanumeric characters
public isolated function removeNonAlphanumeric(string str) returns string {
    return regexp:replaceAll(re `[^a-zA-Z0-9]`, str, "");
}

# Removes all whitespace characters from a string.
#
# + str - The string to process
# + return - String with all whitespace removed
public isolated function removeWhitespace(string str) returns string {
    return regexp:replaceAll(re `\s`, str, "");
}

# Removes specific characters from a string.
#
# + str - The string to process
# + chars - Characters to remove
# + return - String with specified characters removed
public isolated function removeChars(string str, string chars) returns string {
    if str.length() == 0 || chars.length() == 0 {
        return str;
    }
    
    string result = str;
    
    foreach string char in chars {
        // Escape special regex characters
        string escapedChar = char;
        if char == "\\" || char == "." || char == "*" || char == "+" || char == "?" || 
           char == "^" || char == "$" || char == "{" || char == "}" || char == "[" || 
           char == "]" || char == "(" || char == ")" || char == "|" {
            escapedChar = "\\" + char;
        }
        regexp:RegExp|error regexResult = regexp:fromString(escapedChar);
        if regexResult is regexp:RegExp {
            result = regexp:replaceAll(regexResult, result, "");
        }
    }
    
    return result;
}

# Converts a string to a consistent format by making it lowercase and removing diacritics (accents).
#
# + str - The string to normalize
# + options - Normalization options
# + customDiacriticMap - Custom diacritic mappings to extend or override defaults
# + return - The normalized string
public isolated function normalize(string str, NormalizationOptions? options = (), map<string>? customDiacriticMap = ()) returns string {
    if str.length() == 0 {
        return str;
    }
    
    NormalizationOptions opts = options ?: {
        lowercase: true,
        removeDiacritics: true,
        collapseWhitespace: true,
        trim: true
    };
    
    string result = str;
    
    // Remove diacritics (simplified version - covers common cases)
    if opts.removeDiacritics == true {
        result = removeDiacritics(result, customDiacriticMap);
    }
    
    // Convert to lowercase
    if opts.lowercase == true {
        result = result.toLowerAscii();
    }
    
    // Collapse whitespace
    if opts.collapseWhitespace == true {
        result = regexp:replaceAll(re `\s+`, result, " ");
    }
    
    // Trim
    if opts.trim == true {
        result = result.trim();
    }
    
    return result;
}

# Helper function to remove common diacritics/accents
#
# + str - The string to process
# + customMappings - Optional custom diacritic mappings to extend or override defaults
# + return - String with diacritics removed
isolated function removeDiacritics(string str, map<string>? customMappings = ()) returns string {
    string result = str;
    
    // Extended diacritic mappings covering more languages and characters
    final map<string> defaultDiacriticMap = {
        // Latin A
        "à|á|â|ã|ä|å|ā|ă|ą|ǎ|ǟ|ǡ|ǻ|ȁ|ȃ|ȧ|ḁ|ạ|ả|ấ|ầ|ẩ|ẫ|ậ|ắ|ằ|ẳ|ẵ|ặ": "a",
        "À|Á|Â|Ã|Ä|Å|Ā|Ă|Ą|Ǎ|Ǟ|Ǡ|Ǻ|Ȁ|Ȃ|Ȧ|Ḁ|Ạ|Ả|Ấ|Ầ|Ẩ|Ẫ|Ậ|Ắ|Ằ|Ẳ|Ẵ|Ặ": "A",
        // Latin E
        "è|é|ê|ë|ē|ĕ|ė|ę|ě|ȅ|ȇ|ȩ|ḕ|ḗ|ḙ|ḛ|ḝ|ẹ|ẻ|ẽ|ế|ề|ể|ễ|ệ": "e",
        "È|É|Ê|Ë|Ē|Ĕ|Ė|Ę|Ě|Ȅ|Ȇ|Ȩ|Ḕ|Ḗ|Ḙ|Ḛ|Ḝ|Ẹ|Ẻ|Ẽ|Ế|Ề|Ể|Ễ|Ệ": "E",
        // Latin I
        "ì|í|î|ï|ĩ|ī|ĭ|į|ı|ǐ|ȉ|ȋ|ḭ|ḯ|ỉ|ị": "i",
        "Ì|Í|Î|Ï|Ĩ|Ī|Ĭ|Į|İ|Ǐ|Ȉ|Ȋ|Ḭ|Ḯ|Ỉ|Ị": "I",
        // Latin O
        "ò|ó|ô|õ|ö|ø|ō|ŏ|ő|ơ|ǒ|ǫ|ǭ|ǿ|ȍ|ȏ|ȫ|ȭ|ȯ|ȱ|ḍ|ḏ|ḑ|ḓ|ọ|ỏ|ố|ồ|ổ|ỗ|ộ|ớ|ờ|ở|ỡ|ợ": "o",
        "Ò|Ó|Ô|Õ|Ö|Ø|Ō|Ŏ|Ő|Ơ|Ǒ|Ǫ|Ǭ|Ǿ|Ȍ|Ȏ|Ȫ|Ȭ|Ȯ|Ȱ|Ḍ|Ḏ|Ḑ|Ḓ|Ọ|Ỏ|Ố|Ồ|Ổ|Ỗ|Ộ|Ớ|Ờ|Ở|Ỡ|Ợ": "O",
        // Latin U
        "ù|ú|û|ü|ũ|ū|ŭ|ů|ű|ų|ư|ǔ|ǖ|ǘ|ǚ|ǜ|ȕ|ȗ|ṳ|ṵ|ṷ|ṹ|ṻ|ụ|ủ|ứ|ừ|ử|ữ|ự": "u",
        "Ù|Ú|Û|Ü|Ũ|Ū|Ŭ|Ů|Ű|Ų|Ư|Ǔ|Ǖ|Ǘ|Ǚ|Ǜ|Ȕ|Ȗ|Ṳ|Ṵ|Ṷ|Ṹ|Ṻ|Ụ|Ủ|Ứ|Ừ|Ử|Ữ|Ự": "U",
        // Latin Y
        "ý|ÿ|ŷ|ȳ|ẏ|ỳ|ỵ|ỷ|ỹ": "y",
        "Ý|Ÿ|Ŷ|Ȳ|Ẏ|Ỳ|Ỵ|Ỷ|Ỹ": "Y",
        // Other common letters
        "ñ|ń|ņ|ň|ŉ|ǹ|ṅ|ṇ|ṉ|ṋ": "n",
        "Ñ|Ń|Ņ|Ň|Ǹ|Ṅ|Ṇ|Ṉ|Ṋ": "N",
        "ç|ć|ĉ|ċ|č|ḉ": "c",
        "Ç|Ć|Ĉ|Ċ|Č|Ḉ": "C",
        "ß": "ss",
        "æ": "ae",
        "Æ": "AE",
        "œ": "oe",
        "Œ": "OE",
        "ð": "d",
        "Ð": "D",
        "þ": "th",
        "Þ": "TH",
        // Additional characters
        "ĝ|ğ|ġ|ģ|ǧ|ǵ|ḡ": "g",
        "Ĝ|Ğ|Ġ|Ģ|Ǧ|Ǵ|Ḡ": "G",
        "ĥ|ħ|ḣ|ḥ|ḧ|ḩ|ḫ": "h",
        "Ĥ|Ħ|Ḣ|Ḥ|Ḧ|Ḩ|Ḫ": "H",
        "ĵ|ǰ": "j",
        "Ĵ": "J",
        "ķ|ḱ|ḳ|ḵ": "k",
        "Ķ|Ḱ|Ḳ|Ḵ": "K",
        "ĺ|ļ|ľ|ŀ|ł|ḷ|ḹ|ḻ|ḽ": "l",
        "Ĺ|Ļ|Ľ|Ŀ|Ł|Ḷ|Ḹ|Ḻ|Ḽ": "L",
        "ŕ|ŗ|ř|ȑ|ȓ|ṙ|ṛ|ṝ|ṟ": "r",
        "Ŕ|Ŗ|Ř|Ȑ|Ȓ|Ṙ|Ṛ|Ṝ|Ṟ": "R",
        "ś|ŝ|ş|š|ș|ṡ|ṣ|ṥ|ṧ|ṩ": "s",
        "Ś|Ŝ|Ş|Š|Ș|Ṡ|Ṣ|Ṥ|Ṧ|Ṩ": "S",
        "ţ|ť|ŧ|ț|ṫ|ṭ|ṯ|ṱ": "t",
        "Ţ|Ť|Ŧ|Ț|Ṫ|Ṭ|Ṯ|Ṱ": "T",
        "ŵ|ẁ|ẃ|ẅ|ẇ|ẉ": "w",
        "Ŵ|Ẁ|Ẃ|Ẅ|Ẇ|Ẉ": "W",
        "ź|ż|ž|ẑ|ẓ|ẕ": "z",
        "Ź|Ż|Ž|Ẑ|Ẓ|Ẕ": "Z"
    };
    
    // Merge custom mappings with defaults (custom mappings take precedence)
    map<string> finalMappings = defaultDiacriticMap;
    if customMappings is map<string> {
        foreach [string, string] [pattern, replacement] in customMappings.entries() {
            finalMappings[pattern] = replacement;
        }
    }
    
    foreach [string, string] [pattern, replacement] in finalMappings.entries() {
        regexp:RegExp|error regexResult = regexp:fromString("[" + pattern + "]");
        if regexResult is regexp:RegExp {
            result = regexp:replaceAll(regexResult, result, replacement);
        }
    }
    
    return result;
}

# Removes specific characters from the beginning and end of a string.
#
# + str - The string to process
# + chars - Characters to remove from start and end
# + return - String with specified characters trimmed
public isolated function trimChars(string str, string chars) returns string {
    if str.length() == 0 || chars.length() == 0 {
        return str;
    }
    
    string result = str;
    
    // Create character class pattern for trimming
    string charPattern = "";
    foreach string char in chars {
        if char == "\\" || char == "." || char == "*" || char == "+" || char == "?" || 
           char == "^" || char == "$" || char == "{" || char == "}" || char == "[" || 
           char == "]" || char == "(" || char == ")" || char == "|" || char == "-" {
            charPattern += "\\" + char;
        } else {
            charPattern += char;
        }
    }
    
    // Trim from start and end
    regexp:RegExp|error regexResult = regexp:fromString("^[" + charPattern + "]+|[" + charPattern + "]+$");
    if regexResult is regexp:RegExp {
        result = regexp:replaceAll(regexResult, result, "");
    }
    
    return result;
}

# Removes consecutive duplicate characters, optionally keeping a specified number.
#
# + str - The string to process
# + keepCount - Number of consecutive characters to keep (default: 1)
# + return - String with consecutive duplicates removed
public isolated function removeConsecutiveDuplicates(string str, int keepCount = 1) returns string {
    if str.length() == 0 || keepCount < 1 {
        return str;
    }
    
    string result = "";
    string? lastChar = ();
    int consecutiveCount = 0;
    
    foreach string char in str {
        if lastChar is string && char == lastChar {
            consecutiveCount += 1;
            if consecutiveCount < keepCount {
                result += char;
            }
        } else {
            result += char;
            lastChar = char;
            consecutiveCount = 0;
        }
    }
    
    return result;
}

# Removes all control characters (non-printable characters) from a string.
#
# + str - The string to process
# + return - String with control characters removed
public isolated function removeControlCharacters(string str) returns string {
    // Remove common control characters step by step
    string result = str;
    result = regexp:replaceAll(re `\t`, result, "");     // tab
    result = regexp:replaceAll(re `\n`, result, "");     // newline
    result = regexp:replaceAll(re `\r`, result, "");     // carriage return
    return result;
}
