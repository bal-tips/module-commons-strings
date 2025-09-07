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

# Pads the start of a string with a character until it reaches a specified length.
#
# + str - The string to pad
# + length - The target length
# + padChar - The character to pad with (default: " ")
# + return - The left-padded string
public isolated function padLeft(string str, int length, string padChar = " ") returns string {
    if str.length() >= length {
        return str;
    }
    
    int padCount = length - str.length();
    string padding = "";
    
    foreach int i in 0..<padCount {
        padding += padChar;
    }
    
    return padding + str;
}

# Pads the end of a string with a character until it reaches a specified length.
#
# + str - The string to pad
# + length - The target length
# + padChar - The character to pad with (default: " ")
# + return - The right-padded string
public isolated function padRight(string str, int length, string padChar = " ") returns string {
    if str.length() >= length {
        return str;
    }
    
    int padCount = length - str.length();
    string padding = "";
    
    foreach int i in 0..<padCount {
        padding += padChar;
    }
    
    return str + padding;
}

# Pads both sides of a string to center it within a specified length.
#
# + str - The string to pad
# + length - The target length
# + padChar - The character to pad with (default: " ")
# + return - The center-padded string
public isolated function padCenter(string str, int length, string padChar = " ") returns string {
    if str.length() >= length {
        return str;
    }
    
    int totalPadding = length - str.length();
    int leftPadding = totalPadding / 2;
    int rightPadding = totalPadding - leftPadding;
    
    string leftPad = "";
    string rightPad = "";
    
    foreach int i in 0..<leftPadding {
        leftPad += padChar;
    }
    
    foreach int i in 0..<rightPadding {
        rightPad += padChar;
    }
    
    return leftPad + str + rightPad;
}

# Generic padding function with options
#
# + str - The string to pad
# + options - Padding options
# + return - The padded string
public isolated function pad(string str, PaddingOptions options) returns string {
    if options.truncate == true && str.length() > options.length {
        return str.substring(0, options.length);
    }
    
    string padChar = options.padChar ?: " ";
    PadDirection direction = options.direction ?: LEFT;
    
    match direction {
        LEFT => {
            return padLeft(str, options.length, padChar);
        }
        RIGHT => {
            return padRight(str, options.length, padChar);
        }
        _ => { // CENTER
            return padCenter(str, options.length, padChar);
        }
    }
}

# Truncates a string to a maximum length, appending an optional suffix.
#
# + str - The string to truncate
# + maxLength - The maximum length
# + suffix - The suffix to append (default: "...")
# + return - The truncated string
public isolated function truncate(string str, int maxLength, string suffix = "...") returns string {
    if str.length() <= maxLength {
        return str;
    }
    
    if maxLength <= suffix.length() {
        return str.substring(0, maxLength);
    }
    
    int contentLength = maxLength - suffix.length();
    return str.substring(0, contentLength) + suffix;
}

# Truncates a string at word boundaries to avoid cutting words in half.
#
# + str - The string to truncate
# + maxLength - The maximum length
# + suffix - The suffix to append (default: "...")
# + return - The truncated string
public isolated function truncateWords(string str, int maxLength, string suffix = "...") returns string {
    if str.length() <= maxLength {
        return str;
    }
    
    if maxLength <= suffix.length() {
        return str.substring(0, maxLength);
    }
    
    int contentLength = maxLength - suffix.length();
    string content = str.substring(0, contentLength);
    
    // Find the last space to avoid cutting words
    int? lastSpaceIndex = content.lastIndexOf(" ");
    if lastSpaceIndex is int && lastSpaceIndex > 0 {
        content = content.substring(0, lastSpaceIndex);
    }
    
    return content + suffix;
}

# Truncates a string in the middle, keeping start and end portions visible.
#
# + str - The string to truncate
# + maxLength - The maximum length
# + suffix - The suffix to show in the middle (default: "...")
# + return - The truncated string
public isolated function truncateMiddle(string str, int maxLength, string suffix = "...") returns string {
    if str.length() <= maxLength {
        return str;
    }
    
    if maxLength <= suffix.length() {
        return str.substring(0, maxLength);
    }
    
    int availableLength = maxLength - suffix.length();
    int startLength = availableLength / 2;
    int endLength = availableLength - startLength;
    
    string startPart = str.substring(0, startLength);
    string endPart = str.substring(str.length() - endLength);
    
    return startPart + suffix + endPart;
}

# Advanced truncation with multiple options
#
# + str - The string to truncate
# + options - Truncation options
# + return - The truncated string
public isolated function truncateAdvanced(string str, TruncationOptions options) returns string {
    if str.length() <= options.maxLength {
        return str;
    }
    
    string suffix = options.suffix ?: "...";
    TruncationStrategy strategy = options.strategy ?: END;
    
    match strategy {
        END => {
            if options.preserveWords == true {
                return truncateWords(str, options.maxLength, suffix);
            } else {
                return truncate(str, options.maxLength, suffix);
            }
        }
        MIDDLE => {
            return truncateMiddle(str, options.maxLength, suffix);
        }
        _ => { // WORD
            return truncateWords(str, options.maxLength, suffix);
        }
    }
}
