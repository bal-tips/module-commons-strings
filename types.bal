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

# Represents different case conversion types
public enum CaseType {
    # Camel case (e.g., "firstName")
    CAMEL = "camel",
    # Snake case (e.g., "first_name")
    SNAKE = "snake",
    # Kebab case (e.g., "first-name")
    KEBAB = "kebab",
    # Title case (e.g., "First Name")
    TITLE = "title",
    # Upper case (e.g., "FIRST NAME")
    UPPER = "upper",
    # Lower case (e.g., "first name")
    LOWER = "lower"
}

# Represents padding direction
public enum PadDirection {
    # Pad on the left side
    LEFT = "left",
    # Pad on the right side
    RIGHT = "right",
    # Pad on both sides (center)
    CENTER = "center"
}

# Represents truncation strategy
public enum TruncationStrategy {
    # Truncate at the end with suffix
    END = "end",
    # Truncate in the middle with suffix
    MIDDLE = "middle",
    # Truncate at word boundary
    WORD = "word"
}

# Represents character categories for filtering
public enum CharacterCategory {
    # Alphabetic characters (a-z, A-Z)
    ALPHA = "alpha",
    # Numeric characters (0-9)
    NUMERIC = "numeric",
    # Alphanumeric characters (a-z, A-Z, 0-9)
    ALPHANUMERIC = "alphanumeric",
    # Whitespace characters
    WHITESPACE = "whitespace",
    # Special/symbol characters
    SPECIAL = "special"
}

# Options for the mask function
public type MaskOptions record {|
    # Number of characters to keep visible at the start
    int visibleStart?;
    # Number of characters to keep visible at the end
    int visibleEnd?;
    # Character to use for masking (default: '*')
    string maskChar?;
    # Minimum length before masking is applied
    int minLength?;
|};

# Options for truncation
public type TruncationOptions record {|
    # Maximum length of the resulting string
    int maxLength;
    # Suffix to append when truncating (default: "...")
    string suffix?;
    # Strategy for truncation
    TruncationStrategy strategy?;
    # Preserve word boundaries when truncating
    boolean preserveWords?;
|};

# Options for normalization
public type NormalizationOptions record {|
    # Convert to lowercase
    boolean lowercase?;
    # Remove diacritics/accents
    boolean removeDiacritics?;
    # Collapse multiple whitespace into single space
    boolean collapseWhitespace?;
    # Trim leading and trailing whitespace
    boolean trim?;
|};

# Options for padding
public type PaddingOptions record {|
    # Total length after padding
    int length;
    # Character to use for padding (default: " ")
    string padChar?;
    # Direction to pad
    PadDirection direction?;
    # Truncate if string is longer than target length
    boolean truncate?;
|};

# Options for phone number masking
public type PhoneMaskOptions record {|
    # Number of digits to keep visible at the start (country code area)
    int visibleStart?;
    # Number of digits to keep visible at the end
    int visibleEnd?;
    # Character to use for masking (default: '*')
    string maskChar?;
    # Whether to preserve original formatting (brackets, spaces, hyphens)
    boolean preserveFormatting?;
    # Minimum length before masking is applied
    int minLength?;
|};

# Options for credit card masking
public type CreditCardMaskOptions record {|
    # Number of digits to keep visible at the start
    int visibleStart?;
    # Number of digits to keep visible at the end
    int visibleEnd?;
    # Character to use for masking (default: '*')
    string maskChar?;
    # Whether to group masked digits (e.g., ****-****-****-1234)
    boolean groupDigits?;
    # Minimum length before masking is applied
    int minLength?;
|};

# Options for email masking
public type EmailMaskOptions record {|
    # Number of characters to keep visible at the start of local part
    int localVisibleStart?;
    # Number of characters to keep visible at the end of local part
    int localVisibleEnd?;
    # Whether to mask the domain name (default: false)
    boolean maskDomain?;
    # Number of characters to keep visible at the start of domain name (when maskDomain is true)
    int domainVisibleStart?;
    # Number of characters to keep visible at the end of domain name (when maskDomain is true)
    int domainVisibleEnd?;
    # Character to use for masking (default: '*')
    string maskChar?;
    # Minimum length of local part before masking is applied
    int minLocalLength?;
    # Minimum length of domain name before masking is applied (when maskDomain is true)
    int minDomainLength?;
    # What to replace domain extension with when masking domain (default: "***")
    string domainExtensionMask?;
|};
