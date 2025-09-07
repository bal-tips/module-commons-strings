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
function testDefaultIfEmpty() {
    test:assertEquals(defaultIfEmpty((), "default"), "default");
    test:assertEquals(defaultIfEmpty("", "default"), "default");
    test:assertEquals(defaultIfEmpty("value", "default"), "value");
    test:assertEquals(defaultIfEmpty("  ", "default"), "  "); // whitespace is not empty
}

@test:Config {}
function testFirstNonEmpty() {
    test:assertEquals(firstNonEmpty((), "", "first", "second"), "first");
    test:assertEquals(firstNonEmpty("first", "second"), "first");
    test:assertEquals(firstNonEmpty((), ()), "");
    test:assertEquals(firstNonEmpty("value"), "value");
}

@test:Config {}
function testSubstringAfter() {
    test:assertEquals(substringAfter("user@google.com", "@"), "google.com");
    test:assertEquals(substringAfter("hello-world", "-"), "world");
    test:assertEquals(substringAfter("no-separator", "_"), "");
    test:assertEquals(substringAfter("", "@"), "");
    test:assertEquals(substringAfter("test@", "@"), "");
}

@test:Config {}
function testSubstringBefore() {
    test:assertEquals(substringBefore("user@google.com", "@"), "user");
    test:assertEquals(substringBefore("hello-world", "-"), "hello");
    test:assertEquals(substringBefore("no-separator", "_"), "no-separator");
    test:assertEquals(substringBefore("", "@"), "");
    test:assertEquals(substringBefore("@test", "@"), "");
}

@test:Config {}
function testSubstringAfterLast() {
    test:assertEquals(substringAfterLast("/path/to/file.txt", "/"), "file.txt");
    test:assertEquals(substringAfterLast("one.two.three", "."), "three");
    test:assertEquals(substringAfterLast("no-separator", "_"), "no-separator");
    test:assertEquals(substringAfterLast("", "/"), "");
}

@test:Config {}
function testSubstringBeforeLast() {
    test:assertEquals(substringBeforeLast("/path/to/file.txt", "/"), "/path/to");
    test:assertEquals(substringBeforeLast("one.two.three", "."), "one.two");
    test:assertEquals(substringBeforeLast("no-separator", "_"), "");
    test:assertEquals(substringBeforeLast("", "/"), "");
}

@test:Config {}
function testSubstringBetween() {
    test:assertEquals(substringBetween("Hello [World] Text", "[", "]"), "World");
    test:assertEquals(substringBetween("(test)", "(", ")"), "test");
    test:assertEquals(substringBetween("no brackets", "[", "]"), "");
    test:assertEquals(substringBetween("", "[", "]"), "");
    test:assertEquals(substringBetween("[no end", "[", "]"), "");
}

@test:Config {}
function testIsBlank() {
    test:assertTrue(isBlank(()));
    test:assertTrue(isBlank(""));
    test:assertTrue(isBlank("   "));
    test:assertTrue(isBlank("\t\n"));
    test:assertFalse(isBlank("text"));
    test:assertFalse(isBlank(" text "));
}

@test:Config {}
function testIsNotBlank() {
    test:assertFalse(isNotBlank(()));
    test:assertFalse(isNotBlank(""));
    test:assertFalse(isNotBlank("   "));
    test:assertTrue(isNotBlank("text"));
    test:assertTrue(isNotBlank(" text "));
}

@test:Config {}
function testDefaultIfBlank() {
    test:assertEquals(defaultIfBlank((), "default"), "default");
    test:assertEquals(defaultIfBlank("", "default"), "default");
    test:assertEquals(defaultIfBlank("   ", "default"), "default");
    test:assertEquals(defaultIfBlank("value", "default"), "value");
}

@test:Config {}
function testToIntOrDefault() {
    test:assertEquals(toIntOrDefault("123", 0), 123);
    test:assertEquals(toIntOrDefault("abc", 0), 0);
    test:assertEquals(toIntOrDefault("", 42), 42);
    test:assertEquals(toIntOrDefault("-456", 0), -456);
}

@test:Config {}
function testToDecimalOrDefault() {
    test:assertEquals(toDecimalOrDefault("12.34", 0.0d), 12.34d);
    test:assertEquals(toDecimalOrDefault("abc", 0.0d), 0.0d);
    test:assertEquals(toDecimalOrDefault("", 1.5d), 1.5d);
    test:assertEquals(toDecimalOrDefault("-12.34", 0.0d), -12.34d);
}
