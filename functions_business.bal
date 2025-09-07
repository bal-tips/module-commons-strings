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

# Masks a portion of a string, useful for redacting PII before sending data to an external service or LLM.
#
# + str - The string to mask
# + visibleStart - Number of characters to keep visible at the start
# + visibleEnd - Number of characters to keep visible at the end
# + maskChar - Character to use for masking (default: '*')
# + return - The masked string
public isolated function mask(string str, int visibleStart, int visibleEnd, string maskChar = "*") returns string {
    if str.length() == 0 {
        return str;
    }
    
    int totalVisible = visibleStart + visibleEnd;
    if totalVisible >= str.length() {
        return str; // String is too short to mask meaningfully
    }
    
    string startPart = str.substring(0, visibleStart);
    string endPart = str.substring(str.length() - visibleEnd);
    
    int maskLength = str.length() - totalVisible;
    string maskPart = "";
    foreach int i in 0..<maskLength {
        maskPart += maskChar;
    }
    
    return startPart + maskPart + endPart;
}

# Advanced masking with options.
#
# + str - The string to mask
# + options - Masking options
# + return - The masked string
public isolated function maskAdvanced(string str, MaskOptions options) returns string {
    if str.length() == 0 {
        return str;
    }
    
    int minLength = options.minLength ?: 4;
    if str.length() < minLength {
        return str; // Don't mask short strings
    }
    
    int visibleStart = options.visibleStart ?: 2;
    int visibleEnd = options.visibleEnd ?: 2;
    string maskChar = options.maskChar ?: "*";
    
    return mask(str, visibleStart, visibleEnd, maskChar);
}

# Masks email addresses with configurable options for local part and domain.
#
# + email - The email address to mask
# + options - Email masking options
# + return - The masked email address
public isolated function maskEmail(string email, EmailMaskOptions? options = ()) returns string {
    EmailMaskOptions opts = options ?: {
        localVisibleStart: 1,
        localVisibleEnd: 1,
        maskDomain: false,
        domainVisibleStart: 1,
        domainVisibleEnd: 1,
        maskChar: "*",
        minLocalLength: 3,
        minDomainLength: 3,
        domainExtensionMask: "***"
    };
    
    int? atIndex = email.indexOf("@");
    if atIndex is () {
        return mask(email, 2, 2, opts.maskChar ?: "*"); // Not a valid email, just mask normally
    }
    
    string localPart = email.substring(0, atIndex);
    string domainPart = email.substring(atIndex);
    
    int localVisibleStart = opts.localVisibleStart ?: 1;
    int localVisibleEnd = opts.localVisibleEnd ?: 1;
    int minLocalLength = opts.minLocalLength ?: 3;
    string maskChar = opts.maskChar ?: "*";
    boolean maskDomain = opts.maskDomain ?: false;
    
    string maskedLocal;
    if localPart.length() < minLocalLength {
        maskedLocal = localPart; // Keep short local parts visible
    } else {
        maskedLocal = mask(localPart, localVisibleStart, localVisibleEnd, maskChar);
    }
    
    if !maskDomain {
        return maskedLocal + domainPart;
    }
    
    // Mask domain if requested
    int domainVisibleStart = opts.domainVisibleStart ?: 1;
    int domainVisibleEnd = opts.domainVisibleEnd ?: 1;
    int minDomainLength = opts.minDomainLength ?: 3;
    string domainExtensionMask = opts.domainExtensionMask ?: "***";
    
    // Extract domain name and extension
    int? dotIndex = domainPart.lastIndexOf(".");
    if dotIndex is () {
        // No extension found, mask the whole domain part (minus @)
        string domainName = domainPart.substring(1);
        if domainName.length() < minDomainLength {
            return maskedLocal + "@" + domainName;
        }
        return maskedLocal + "@" + mask(domainName, domainVisibleStart, domainVisibleEnd, maskChar);
    }
    
    string domainName = domainPart.substring(1, dotIndex);
    
    if domainName.length() < minDomainLength {
        return maskedLocal + "@" + domainName + "." + domainExtensionMask;
    }
    
    string maskedDomainName = mask(domainName, domainVisibleStart, domainVisibleEnd, maskChar);
    return maskedLocal + "@" + maskedDomainName + "." + domainExtensionMask;
}

# Masks phone numbers while keeping country code and last few digits visible.
#
# + phone - The phone number to mask
# + options - Phone masking options
# + return - The masked phone number
public isolated function maskPhone(string phone, PhoneMaskOptions? options = ()) returns string {
    PhoneMaskOptions opts = options ?: {
        visibleStart: (),
        visibleEnd: 2,
        maskChar: "*",
        preserveFormatting: true,
        minLength: 4
    };
    
    // Remove all non-digit characters for processing
    string digits = regexp:replaceAll(re `[^0-9]`, phone, "");
    
    int minLength = opts.minLength ?: 4;
    if digits.length() < minLength {
        return phone; // Too short to mask meaningfully
    }
    
    // Determine visible start based on length if not specified
    int visibleStart = opts.visibleStart ?: (digits.length() >= 10 ? 3 : 1);
    int visibleEnd = opts.visibleEnd ?: 2;
    string maskChar = opts.maskChar ?: "*";
    boolean preserveFormatting = opts.preserveFormatting ?: true;
    
    string maskedDigits = mask(digits, visibleStart, visibleEnd, maskChar);
    
    if !preserveFormatting {
        return maskedDigits;
    }
    
    // Try to preserve original formatting by replacing digits
    string formattedResult = "";
    int maskedIndex = 0;
    
    foreach string char in phone {
        if regexp:isFullMatch(re `[0-9]`, char) {
            if maskedIndex < maskedDigits.length() {
                formattedResult += maskedDigits.substring(maskedIndex, maskedIndex + 1);
                maskedIndex += 1;
            }
        } else {
            formattedResult += char;
        }
    }
    
    return formattedResult;
}

# Masks credit card numbers while keeping first 4 and last 4 digits visible.
#
# + cardNumber - The credit card number to mask
# + options - Credit card masking options
# + return - The masked credit card number
public isolated function maskCreditCard(string cardNumber, CreditCardMaskOptions? options = ()) returns string {
    CreditCardMaskOptions opts = options ?: {
        visibleStart: 4,
        visibleEnd: 4,
        maskChar: "*",
        groupDigits: true,
        minLength: 8
    };
    
    // Remove all non-digit characters
    string digits = regexp:replaceAll(re `[^0-9]`, cardNumber, "");
    
    int minLength = opts.minLength ?: 8;
    if digits.length() < minLength {
        return mask(cardNumber, 2, 2); // Not enough digits for credit card, mask normally
    }
    
    int visibleStart = opts.visibleStart ?: 4;
    int visibleEnd = opts.visibleEnd ?: 4;
    string maskChar = opts.maskChar ?: "*";
    boolean groupDigits = opts.groupDigits ?: true;
    
    string maskedDigits = mask(digits, visibleStart, visibleEnd, maskChar);
    
    if !groupDigits {
        return maskedDigits;
    }
    
    // Group digits in standard credit card format (XXXX-XXXX-XXXX-XXXX)
    string groupedResult = "";
    foreach int i in 0..<maskedDigits.length() {
        if i > 0 && i % 4 == 0 {
            groupedResult += "-";
        }
        groupedResult += maskedDigits.substring(i, i + 1);
    }
    
    return groupedResult;
}

# A smarter truncate that approximates token count to avoid exceeding an LLM's context window limit.
# This is a simplified implementation that estimates tokens by word count.
#
# + str - The string to truncate
# + maxTokens - The maximum number of tokens (approximately)
# + return - The truncated string
public isolated function truncateByToken(string str, int maxTokens) returns string {
    if str.length() == 0 {
        return str;
    }
    
    // Simple token estimation: split by whitespace and punctuation
    string[] words = regexp:split(re `\s+`, str);
    
    if words.length() <= maxTokens {
        return str;
    }
    
    // Take approximately maxTokens words
    string[] truncatedWords = words.slice(0, maxTokens);
    string result = "";
    
    foreach int i in 0..<truncatedWords.length() {
        if i > 0 {
            result += " ";
        }
        result += truncatedWords[i];
    }
    
    return result + "...";
}

# Estimates the approximate token count of a string.
# This is a simplified estimation based on word count and punctuation.
#
# + str - The string to analyze
# + return - Estimated token count
public isolated function estimateTokens(string str) returns int {
    if str.length() == 0 {
        return 0;
    }
    
    // Split by whitespace
    string[] words = regexp:split(re `\s+`, str.trim());
    
    // Count additional tokens for punctuation (simplified)
    int punctuationCount = 0;
    foreach string char in str {
        if regexp:isFullMatch(re `[.,!?;:()\[\]{}"']`, char) {
            punctuationCount += 1;
        }
    }
    
    // Rough estimation: words + punctuation/2 (since some punctuation might be grouped)
    return words.length() + (punctuationCount / 2);
}

# Redacts sensitive patterns like SSNs, credit cards, emails from text.
# WARNING: This is a basic implementation for common patterns. Use with caution in production.
# Consider using specialized libraries or services for robust PII detection and redaction.
#
# + str - The string to redact
# + redactionChar - Character to use for redaction (default: 'X')
# + return - The redacted string
public isolated function redactSensitiveInfo(string str, string redactionChar = "X") returns string {
    string result = str;
    
    // Redact SSN patterns (XXX-XX-XXXX)
    result = regexp:replaceAll(re `\d{3}-\d{2}-\d{4}`, result, repeat(redactionChar, 11));
    
    // Redact credit card patterns (XXXX-XXXX-XXXX-XXXX)
    result = regexp:replaceAll(re `\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}`, result,
                             repeat(redactionChar, 4) + "-" + repeat(redactionChar, 4) + "-" + 
                             repeat(redactionChar, 4) + "-" + repeat(redactionChar, 4));
    
    // Redact email patterns
    result = regexp:replaceAll(re `[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}`, result,
                             repeat(redactionChar, 5) + "@" + repeat(redactionChar, 8) + ".com");
    
    return result;
}

# Helper function to repeat a string n times (for older Ballerina versions that might not have repeat)
#
# + str - The string to repeat
# + times - Number of times to repeat
# + return - The repeated string
isolated function repeat(string str, int times) returns string {
    string result = "";
    foreach int i in 0..<times {
        result += str;
    }
    return result;
}
