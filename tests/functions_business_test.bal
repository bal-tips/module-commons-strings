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

import ballerina/test;

@test:Config {}
function testMask() {
    test:assertEquals(mask("1234567890", 2, 2), "12******90");
    test:assertEquals(mask("hello", 1, 1), "h***o");
    test:assertEquals(mask("ab", 1, 1), "ab"); // Too short to mask
    test:assertEquals(mask("", 1, 1), ""); // Empty string
    test:assertEquals(mask("test", 1, 1, "#"), "t##t");
    
    // Edge cases
    test:assertEquals(mask("a", 0, 0), "*");
    test:assertEquals(mask("password123", 0, 3), "********123");
    test:assertEquals(mask("confidential", 3, 0), "con*********");
}

@test:Config {}
function testMaskAdvanced() {
    MaskOptions options1 = {
        visibleStart: 3,
        visibleEnd: 3,
        maskChar: "#",
        minLength: 8
    };
    test:assertEquals(maskAdvanced("1234567890", options1), "123####890");
    test:assertEquals(maskAdvanced("short", options1), "short"); // Below minLength
    
    MaskOptions options2 = {
        visibleStart: 2,
        visibleEnd: 2,
        minLength: 6
    };
    test:assertEquals(maskAdvanced("testing123", options2), "te******23");
    test:assertEquals(maskAdvanced("test", options2), "test"); // Below minLength
}

@test:Config {}
function testMaskEmail() {
    // Basic email masking (default behavior)
    test:assertEquals(maskEmail("john.doe@example.com"), "j******e@example.com");
    test:assertEquals(maskEmail("a@test.com"), "a@test.com"); // Short local part (below minLocalLength)
    test:assertEquals(maskEmail("ab@test.com"), "ab@test.com"); // Short local part (below minLocalLength)
    test:assertEquals(maskEmail("user@domain.org"), "u**r@domain.org");
    
    // Email masking with domain masking (backward compatibility)
    EmailMaskOptions domainMaskOpts = {
        maskDomain: true
    };
    test:assertEquals(maskEmail("john.doe@example.com", domainMaskOpts), "j******e@e*****e.***");
    test:assertEquals(maskEmail("user@test.org", domainMaskOpts), "u**r@t**t.***");
    test:assertEquals(maskEmail("a@xy.com", domainMaskOpts), "a@xy.***"); // Short domain (below minDomainLength)
    test:assertEquals(maskEmail("test@a.com", domainMaskOpts), "t**t@a.***"); // Single char domain
    
    // Custom local part masking options
    EmailMaskOptions localOpts1 = {
        localVisibleStart: 2,
        localVisibleEnd: 2
    };
    test:assertEquals(maskEmail("john.doe@example.com", localOpts1), "jo****oe@example.com");
    
    EmailMaskOptions localOpts2 = {
        localVisibleStart: 3,
        localVisibleEnd: 0
    };
    test:assertEquals(maskEmail("testuser@example.com", localOpts2), "tes*****@example.com");
    
    // Custom mask character
    EmailMaskOptions maskCharOpts = {
        maskChar: "#"
    };
    test:assertEquals(maskEmail("user@domain.org", maskCharOpts), "u##r@domain.org");
    
    // Custom minimum lengths
    EmailMaskOptions minLengthOpts = {
        minLocalLength: 5
    };
    test:assertEquals(maskEmail("abc@test.com", minLengthOpts), "abc@test.com"); // Below minLocalLength
    test:assertEquals(maskEmail("abcde@test.com", minLengthOpts), "a***e@test.com"); // At minLocalLength
    
    // Domain masking with custom options
    EmailMaskOptions domainOpts1 = {
        maskDomain: true,
        domainVisibleStart: 2,
        domainVisibleEnd: 0,
        domainExtensionMask: "XX"
    };
    test:assertEquals(maskEmail("user@example.com", domainOpts1), "u**r@ex*****.XX");
    
    EmailMaskOptions domainOpts2 = {
        maskDomain: true,
        minDomainLength: 8
    };
    test:assertEquals(maskEmail("user@short.com", domainOpts2), "u**r@short.***"); // Below minDomainLength
    test:assertEquals(maskEmail("user@verylongdomain.com", domainOpts2), "u**r@v************n.***"); // Above minDomainLength
    
    // Combined custom options
    EmailMaskOptions combinedOpts = {
        localVisibleStart: 2,
        localVisibleEnd: 1,
        maskDomain: true,
        domainVisibleStart: 1,
        domainVisibleEnd: 2,
        maskChar: "@",
        domainExtensionMask: "hidden"
    };
    test:assertEquals(maskEmail("testuser@example.com", combinedOpts), "te@@@@@r@e@@@@le.hidden");
    
    // Edge cases
    test:assertEquals(maskEmail("notanemail"), "no******il"); // No @ symbol
    test:assertEquals(maskEmail(""), ""); // Empty string
    test:assertEquals(maskEmail("@domain.com"), "@domain.com"); // No local part
    test:assertEquals(maskEmail("user@"), "u**r@"); // No domain
    test:assertEquals(maskEmail("complex.email+tag@sub.domain.co.uk"), "c***************g@sub.domain.co.uk");
    
    // Complex email with domain masking
    EmailMaskOptions complexOpts = {
        maskDomain: true
    };
    test:assertEquals(maskEmail("complex.email+tag@sub.domain.co.uk", complexOpts), "c***************g@s***********o.***");
    
    // Email without extension
    EmailMaskOptions noExtOpts = {
        maskDomain: true
    };
    test:assertEquals(maskEmail("user@localhost", noExtOpts), "u**r@l*******t");
}

@test:Config {}
function testMaskPhone() {
    // Default behavior
    test:assertEquals(maskPhone("(555) 123-4567"), "(555) ***-**67");
    test:assertEquals(maskPhone("+1-800-555-1234"), "+1-80*-***-**34");
    test:assertEquals(maskPhone("123-456-7890"), "123-***-**90");
    test:assertEquals(maskPhone("1234567890"), "123*****90");
    
    // Custom options - different visible counts
    PhoneMaskOptions opts1 = {
        visibleStart: 1,
        visibleEnd: 4,
        preserveFormatting: true
    };
    test:assertEquals(maskPhone("(555) 123-4567", opts1), "(5**) ***-4567");
    
    PhoneMaskOptions opts2 = {
        visibleStart: 4,
        visibleEnd: 0,
        maskChar: "#"
    };
    test:assertEquals(maskPhone("555-123-4567", opts2), "555-1##-####");
    
    // No formatting preservation
    PhoneMaskOptions opts3 = {
        visibleStart: 3,
        visibleEnd: 2,
        preserveFormatting: false
    };
    test:assertEquals(maskPhone("(555) 123-4567", opts3), "555*****67");
    
    // Different mask characters
    PhoneMaskOptions opts4 = {
        maskChar: "X"
    };
    test:assertEquals(maskPhone("555-123-4567", opts4), "555-XXX-XX67");
    
    // Edge cases
    test:assertEquals(maskPhone("123"), "123"); // Too short
    test:assertEquals(maskPhone(""), ""); // Empty
    test:assertEquals(maskPhone("ext. 1234"), "ext. 1*34"); // Non-standard format
    test:assertEquals(maskPhone("+44 20 7946 0958"), "+44 2* **** **58"); // International
    
    // Minimum length option
    PhoneMaskOptions opts5 = {
        minLength: 8
    };
    test:assertEquals(maskPhone("555-1234", opts5), "555-1234"); // Below minLength
    test:assertEquals(maskPhone("555-12345", opts5), "5**-***45"); // Above minLength
}

@test:Config {}
function testMaskCreditCard() {
    // Default behavior
    test:assertEquals(maskCreditCard("1234567890123456"), "1234-****-****-3456");
    test:assertEquals(maskCreditCard("4111-1111-1111-1111"), "4111-****-****-1111");
    test:assertEquals(maskCreditCard("4111 1111 1111 1111"), "4111-****-****-1111");
    
    // Custom options - different visible counts
    CreditCardMaskOptions opts1 = {
        visibleStart: 6,
        visibleEnd: 2,
        groupDigits: true
    };
    test:assertEquals(maskCreditCard("1234567890123456", opts1), "1234-56**-****-**56");
    
    CreditCardMaskOptions opts2 = {
        visibleStart: 0,
        visibleEnd: 4,
        maskChar: "X"
    };
    test:assertEquals(maskCreditCard("1234567890123456", opts2), "XXXX-XXXX-XXXX-3456");
    
    // No grouping
    CreditCardMaskOptions opts3 = {
        visibleStart: 4,
        visibleEnd: 4,
        groupDigits: false
    };
    test:assertEquals(maskCreditCard("1234567890123456", opts3), "1234********3456");
    
    // Different mask character
    CreditCardMaskOptions opts4 = {
        maskChar: "#"
    };
    test:assertEquals(maskCreditCard("1234567890123456", opts4), "1234-####-####-3456");
    
    // Edge cases
    test:assertEquals(maskCreditCard("1234567"), "12***67"); // Too short for credit card
    test:assertEquals(maskCreditCard(""), ""); // Empty
    test:assertEquals(maskCreditCard("12345"), "12*45"); // Below default minLength
    
    // Minimum length option
    CreditCardMaskOptions opts5 = {
        minLength: 12
    };
    test:assertEquals(maskCreditCard("1234567890", opts5), "12******90"); // Below minLength
    test:assertEquals(maskCreditCard("123456789012", opts5), "1234-****-9012"); // Above minLength
    
    // American Express format (15 digits)
    test:assertEquals(maskCreditCard("123456789012345"), "1234-****-***2-345");
}

@test:Config {}
function testTruncateByToken() {
    test:assertEquals(truncateByToken("one two three four five", 3), "one two three...");
    test:assertEquals(truncateByToken("short", 10), "short");
    test:assertEquals(truncateByToken("", 5), "");
    test:assertEquals(truncateByToken("single", 1), "single");
    
    // Edge cases
    test:assertEquals(truncateByToken("word", 0), "...");
    test:assertEquals(truncateByToken("a b c d e f g", 4), "a b c d...");
    test:assertEquals(truncateByToken("exactly five words here total", 5), "exactly five words here total");
}

@test:Config {}
function testEstimateTokens() {
    test:assertEquals(estimateTokens("hello world"), 2);
    test:assertEquals(estimateTokens(""), 0);
    test:assertEquals(estimateTokens("one"), 1);
    test:assertEquals(estimateTokens("Hello, world!"), 3); // 2 words + 1 for punctuation
    test:assertEquals(estimateTokens("This is a test."), 4); // 4 words + 0.5 for punctuation
    
    // Edge cases
    test:assertEquals(estimateTokens("   spaced   out   "), 2);
    test:assertEquals(estimateTokens("punctuation!!! heavy??? text..."), 7); // 3 words + some punctuation
    test:assertEquals(estimateTokens("no-spaces-here"), 1);
}

@test:Config {}
function testRedactSensitiveInfo() {
    // SSN redaction
    test:assertEquals(redactSensitiveInfo("My SSN is 123-45-6789"), "My SSN is XXXXXXXXXXX");
    test:assertEquals(redactSensitiveInfo("SSNs: 111-22-3333 and 999-88-7777"), 
                     "SSNs: XXXXXXXXXXX and XXXXXXXXXXX");
    
    // Credit card redaction
    test:assertEquals(redactSensitiveInfo("Card: 1234 5678 9012 3456"), 
                     "Card: XXXX-XXXX-XXXX-XXXX");
    test:assertEquals(redactSensitiveInfo("Card: 1234-5678-9012-3456"), 
                     "Card: XXXX-XXXX-XXXX-XXXX");
    test:assertEquals(redactSensitiveInfo("Card: 1234567890123456"), 
                     "Card: XXXX-XXXX-XXXX-XXXX");
    
    // Email redaction
    test:assertEquals(redactSensitiveInfo("Contact: john.doe@example.com"), 
                     "Contact: XXXXX@XXXXXXXX.com");
    test:assertEquals(redactSensitiveInfo("Emails: user@test.org and admin@site.net"), 
                     "Emails: XXXXX@XXXXXXXX.com and XXXXX@XXXXXXXX.com");
    
    // Combined redaction
    test:assertEquals(redactSensitiveInfo("SSN: 123-45-6789, Card: 1234-5678-9012-3456, Email: user@test.com"), 
                     "SSN: XXXXXXXXXXX, Card: XXXX-XXXX-XXXX-XXXX, Email: XXXXX@XXXXXXXX.com");
    
    // Custom redaction character
    test:assertEquals(redactSensitiveInfo("SSN: 123-45-6789", "#"), "SSN: ###########");
    
    // Edge cases
    test:assertEquals(redactSensitiveInfo("No sensitive data here"), "No sensitive data here");
    test:assertEquals(redactSensitiveInfo(""), "");
    test:assertEquals(redactSensitiveInfo("Partial SSN: 123-45-678"), "Partial SSN: 123-45-678"); // Not complete pattern
    test:assertEquals(redactSensitiveInfo("Short card: 1234 5678"), "Short card: 1234 5678"); // Not complete pattern
}

@test:Config {}
function testRepeat() {
    test:assertEquals(repeat("*", 5), "*****");
    test:assertEquals(repeat("abc", 3), "abcabcabc");
    test:assertEquals(repeat("x", 0), "");
    test:assertEquals(repeat("", 5), "");
    test:assertEquals(repeat("test", 1), "test");
}
