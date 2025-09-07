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

# Returns the defaultValue if the input string is () (nil) or empty ("").
#
# + input - The input string (can be nil)
# + defaultValue - The default value to return if input is nil or empty
# + return - The input string or default value
public isolated function defaultIfEmpty(string? input, string defaultValue) returns string {
    if input is () || input.length() == 0 {
        return defaultValue;
    }
    return input;
}

# Returns the first string in a sequence that is not empty or ().
#
# + inputs - Array of input strings (can contain nil values)
# + return - The first non-empty string, or empty string if all are empty/nil
public isolated function firstNonEmpty(string?... inputs) returns string {
    foreach string? input in inputs {
        if input is string && input.length() > 0 {
            return input;
        }
    }
    return "";
}

# Safely gets the part of the string after the first occurrence of a separator.
#
# + str - The input string
# + separator - The separator to search for
# + return - The part after the separator, or empty string if separator not found
public isolated function substringAfter(string str, string separator) returns string {
    int? index = str.indexOf(separator);
    if index is int {
        return str.substring(index + separator.length());
    }
    return "";
}

# Safely gets the part of the string before the first occurrence of a separator.
#
# + str - The input string
# + separator - The separator to search for
# + return - The part before the separator, or the original string if separator not found
public isolated function substringBefore(string str, string separator) returns string {
    int? index = str.indexOf(separator);
    if index is int {
        return str.substring(0, index);
    }
    return str;
}

# Safely gets the part of the string after the last occurrence of a separator.
#
# + str - The input string
# + separator - The separator to search for
# + return - The part after the last separator, or the original string if separator not found
public isolated function substringAfterLast(string str, string separator) returns string {
    int? index = str.lastIndexOf(separator);
    if index is int {
        return str.substring(index + separator.length());
    }
    return str;
}

# Safely gets the part of the string before the last occurrence of a separator.
#
# + str - The input string
# + separator - The separator to search for
# + return - The part before the last separator, or empty string if separator not found
public isolated function substringBeforeLast(string str, string separator) returns string {
    int? index = str.lastIndexOf(separator);
    if index is int {
        return str.substring(0, index);
    }
    return "";
}

# Safely extracts a substring between two separators.
#
# + str - The input string
# + startSeparator - The start separator
# + endSeparator - The end separator
# + return - The substring between separators, or empty string if not found
public isolated function substringBetween(string str, string startSeparator, string endSeparator) returns string {
    int? startIndex = str.indexOf(startSeparator);
    if startIndex is () {
        return "";
    }
    
    int searchStart = startIndex + startSeparator.length();
    int? endIndex = str.indexOf(endSeparator, searchStart);
    if endIndex is () {
        return "";
    }
    
    return str.substring(searchStart, endIndex);
}

# Checks if a string is null, empty, or contains only whitespace.
#
# + str - The string to check
# + return - True if the string is blank
public isolated function isBlank(string? str) returns boolean {
    if str is () {
        return true;
    }
    return str.trim().length() == 0;
}

# Checks if a string is not null, not empty, and contains non-whitespace characters.
#
# + str - The string to check
# + return - True if the string is not blank
public isolated function isNotBlank(string? str) returns boolean {
    return !isBlank(str);
}

# Returns the string if it's not blank, otherwise returns the default value.
#
# + str - The input string
# + defaultValue - The default value to return if string is blank
# + return - The string or default value
public isolated function defaultIfBlank(string? str, string defaultValue) returns string {
    if isBlank(str) {
        return defaultValue;
    }
    return str ?: "";
}

# Safely converts a string to an integer with a default value.
#
# + str - The string to convert
# + defaultValue - The default value if conversion fails
# + return - The integer value or default
public isolated function toIntOrDefault(string str, int defaultValue) returns int {
    int|error result = int:fromString(str);
    if result is error {
        return defaultValue;
    }
    return result;
}

# Safely converts a string to a decimal with a default value.
#
# + str - The string to convert
# + defaultValue - The default value if conversion fails
# + return - The decimal value or default
public isolated function toDecimalOrDefault(string str, decimal defaultValue) returns decimal {
    decimal|error result = decimal:fromString(str);
    if result is error {
        return defaultValue;
    }
    return result;
}
