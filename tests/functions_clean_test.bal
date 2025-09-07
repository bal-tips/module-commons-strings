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
function testTrimAndClean() {
    test:assertEquals(trimAndClean("  hello    world  "), "hello world");
    test:assertEquals(trimAndClean("   multiple   spaces   "), "multiple spaces");
    test:assertEquals(trimAndClean(""), "");
    test:assertEquals(trimAndClean("   "), "");
    test:assertEquals(trimAndClean("no-spaces"), "no-spaces");
    
    // Edge cases
    test:assertEquals(trimAndClean("\t\n  hello\r\n  world  \t"), "hello world");
    test:assertEquals(trimAndClean("single"), "single");
    test:assertEquals(trimAndClean("   a   "), "a");
    test:assertEquals(trimAndClean("multiple\n\t\r   \nspaces"), "multiple spaces");
}

@test:Config {}
function testRemoveNonNumeric() {
    test:assertEquals(removeNonNumeric("Order: (123)-456"), "123456");
    test:assertEquals(removeNonNumeric("ID-98765-A"), "98765");
    test:assertEquals(removeNonNumeric("abc123def456"), "123456");
    test:assertEquals(removeNonNumeric(""), "");
    test:assertEquals(removeNonNumeric("abc"), "");
    test:assertEquals(removeNonNumeric("123"), "123");
    
    // Edge cases
    test:assertEquals(removeNonNumeric("0"), "0");
    test:assertEquals(removeNonNumeric("0123456789"), "0123456789");
    test:assertEquals(removeNonNumeric("!@#$%^&*()"), "");
    test:assertEquals(removeNonNumeric("1.5 + 2.3 = 3.8"), "152338");
    test:assertEquals(removeNonNumeric("Price: $99.99"), "9999");
}

@test:Config {}
function testRemoveNonAlpha() {
    test:assertEquals(removeNonAlpha("John123Doe456"), "JohnDoe");
    test:assertEquals(removeNonAlpha("Hello, World! 123"), "HelloWorld");
    test:assertEquals(removeNonAlpha(""), "");
    test:assertEquals(removeNonAlpha("123"), "");
    test:assertEquals(removeNonAlpha("abc"), "abc");
    
    // Edge cases
    test:assertEquals(removeNonAlpha("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    test:assertEquals(removeNonAlpha("abcdefghijklmnopqrstuvwxyz"), "abcdefghijklmnopqrstuvwxyz");
    test:assertEquals(removeNonAlpha("!@#$%^&*()1234567890"), "");
    test:assertEquals(removeNonAlpha("Café123"), "Caf");
    test:assertEquals(removeNonAlpha("A1B2C3"), "ABC");
}

@test:Config {}
function testRemoveNonAlphanumeric() {
    test:assertEquals(removeNonAlphanumeric("Hello, World! 123"), "HelloWorld123");
    test:assertEquals(removeNonAlphanumeric("Test-123_ABC"), "Test123ABC");
    test:assertEquals(removeNonAlphanumeric(""), "");
    test:assertEquals(removeNonAlphanumeric("!@#$%"), "");
    test:assertEquals(removeNonAlphanumeric("abc123"), "abc123");
    
    // Edge cases
    test:assertEquals(removeNonAlphanumeric("A1a"), "A1a");
    test:assertEquals(removeNonAlphanumeric("User@Domain.com"), "UserDomaincom");
    test:assertEquals(removeNonAlphanumeric("(555) 123-4567"), "5551234567");
    test:assertEquals(removeNonAlphanumeric("Special chars: !@#$%^&*()"), "Specialchars");
    test:assertEquals(removeNonAlphanumeric("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"), "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
}

@test:Config {}
function testRemoveWhitespace() {
    test:assertEquals(removeWhitespace("Hello World"), "HelloWorld");
    test:assertEquals(removeWhitespace("  spaced  out  "), "spacedout");
    test:assertEquals(removeWhitespace(""), "");
    test:assertEquals(removeWhitespace("nospace"), "nospace");
    
    // Edge cases
    test:assertEquals(removeWhitespace("\t\n\r "), "");
    test:assertEquals(removeWhitespace("a b c d e"), "abcde");
    test:assertEquals(removeWhitespace("   only   spaces   "), "onlyspaces");
    test:assertEquals(removeWhitespace("Mixed\tTabs\nAnd\rSpaces"), "MixedTabsAndSpaces");
}

@test:Config {}
function testRemoveChars() {
    test:assertEquals(removeChars("Hello-World!", "-!"), "HelloWorld");
    test:assertEquals(removeChars("test@email.com", "@."), "testemailcom");
    test:assertEquals(removeChars("", "abc"), "");
    test:assertEquals(removeChars("hello", ""), "hello");
    
    // Edge cases
    test:assertEquals(removeChars("Special: ()[]{}^$*+?|\\.", "()[]{}^$*+?|\\."), "Special: ");
    test:assertEquals(removeChars("Remove all vowels", "aeiouAEIOU"), "Rmv ll vwls");
    test:assertEquals(removeChars("1234567890", "0123456789"), "");
    test:assertEquals(removeChars("Keep consonants", "aeiou"), "Kp cnsnnts");
    test:assertEquals(removeChars("Multiple---dashes", "-"), "Multipledashes");
}

@test:Config {}
function testNormalize() {
    test:assertEquals(normalize("JOSÉ Niño"), "jose nino");
    test:assertEquals(normalize("  MÚLTIPLE  SPÁCÉS  "), "multiple spaces");
    test:assertEquals(normalize(""), "");
    
    // Test with custom options
    string customNorm = normalize("  JOSÉ  Niño  ", {
        lowercase: true,
        removeDiacritics: true,
        collapseWhitespace: true,
        trim: true
    });
    test:assertEquals(customNorm, "jose nino");
    
    // Extended edge cases
    test:assertEquals(normalize("Café Crème"), "cafe creme");
    test:assertEquals(normalize("Naïve résumé"), "naive resume");
    test:assertEquals(normalize("Björk Guðmundsdóttir"), "bjork gudmundsdottir");
    test:assertEquals(normalize("François Curaçao"), "francois curacao");
    
    // Test with custom diacritic mappings using characters not in defaults
    map<string> customMap = {"ß": "ss", "œ": "oe"};
    test:assertEquals(normalize("Weiß Cœur", (), customMap), "weiss coeur");
    
    // Test individual options
    test:assertEquals(normalize("CAFÉ", {lowercase: true, removeDiacritics: false}), "café");
    test:assertEquals(normalize("café", {lowercase: false, removeDiacritics: true}), "cafe");
    test:assertEquals(normalize("  hello  world  ", {trim: false, collapseWhitespace: true}), " hello world ");
}

@test:Config {}
function testTrimChars() {
    test:assertEquals(trimChars("...hello...", "."), "hello");
    test:assertEquals(trimChars("---test---", "-"), "test");
    test:assertEquals(trimChars("", "abc"), "");
    test:assertEquals(trimChars("hello", ""), "hello");
    test:assertEquals(trimChars("abcdefabc", "abc"), "def");
    
    // Edge cases
    test:assertEquals(trimChars("!!!important!!!", "!"), "important");
    test:assertEquals(trimChars("***bold***", "*"), "bold");
    test:assertEquals(trimChars("   spaces   ", " "), "spaces");
    test:assertEquals(trimChars("()brackets()", "()"), "brackets");
    test:assertEquals(trimChars("...-mix-...", ".-"), "mix");
}

@test:Config {}
function testRemoveConsecutiveDuplicates() {
    test:assertEquals(removeConsecutiveDuplicates("aabbcc"), "abc");
    test:assertEquals(removeConsecutiveDuplicates("hello"), "helo");
    test:assertEquals(removeConsecutiveDuplicates(""), "");
    test:assertEquals(removeConsecutiveDuplicates("abc"), "abc");
    test:assertEquals(removeConsecutiveDuplicates("aaabbbccc", 2), "aabbcc");
    
    // Edge cases
    test:assertEquals(removeConsecutiveDuplicates("aaaaaa"), "a");
    test:assertEquals(removeConsecutiveDuplicates("bookkeeper"), "bokeper");
    test:assertEquals(removeConsecutiveDuplicates("mississippi"), "misisipi");
    test:assertEquals(removeConsecutiveDuplicates("   multiple   spaces   "), " multiple spaces ");
    test:assertEquals(removeConsecutiveDuplicates("aaa", 0), "aaa"); // Invalid keepCount, returns original
    test:assertEquals(removeConsecutiveDuplicates("aaa", 3), "aaa");
}

@test:Config {}
function testRemoveControlCharacters() {
    test:assertEquals(removeControlCharacters("hello\nworld"), "helloworld");
    test:assertEquals(removeControlCharacters("test\tstring"), "teststring");
    test:assertEquals(removeControlCharacters(""), "");
    test:assertEquals(removeControlCharacters("normal text"), "normal text");
    
    // Edge cases
    test:assertEquals(removeControlCharacters("line1\r\nline2"), "line1line2");
    test:assertEquals(removeControlCharacters("bell sound"), "bell sound");
    test:assertEquals(removeControlCharacters("form feed"), "form feed");
    test:assertEquals(removeControlCharacters("vertical tab"), "vertical tab");
    test:assertEquals(removeControlCharacters("null unit"), "null unit");
}
