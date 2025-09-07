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
function testPadLeft() {
    test:assertEquals(padLeft("45", 5, "0"), "00045");
    test:assertEquals(padLeft("123", 3, "0"), "123");
    test:assertEquals(padLeft("123", 2, "0"), "123"); // Already longer
    test:assertEquals(padLeft("", 3, "x"), "xxx");
}

@test:Config {}
function testPadRight() {
    test:assertEquals(padRight("Apple", 10, " "), "Apple     ");
    test:assertEquals(padRight("test", 4, " "), "test");
    test:assertEquals(padRight("test", 2, " "), "test"); // Already longer
    test:assertEquals(padRight("", 3, "x"), "xxx");
}

@test:Config {}
function testPadCenter() {
    test:assertEquals(padCenter("Hi", 6, "*"), "**Hi**");
    test:assertEquals(padCenter("test", 6, "-"), "-test-");
    test:assertEquals(padCenter("odd", 8, "x"), "xxoddxxx"); // Odd padding
    test:assertEquals(padCenter("test", 4, " "), "test");
}

@test:Config {}
function testTruncate() {
    test:assertEquals(truncate("This is a very long description", 20), "This is a very lo..."); // Fixed expectation
    test:assertEquals(truncate("short", 20), "short");
    test:assertEquals(truncate("test", 3), "tes"); // Fixed expectation
    test:assertEquals(truncate("", 5), "");
}

@test:Config {}
function testTruncateWords() {
    test:assertEquals(truncateWords("This is a very long description", 20), "This is a very...");
    test:assertEquals(truncateWords("short", 20), "short");
    test:assertEquals(truncateWords("NoSpacesHere", 8), "NoSpa...");
}

@test:Config {}
function testTruncateMiddle() {
    test:assertEquals(truncateMiddle("/very/long/file/path/name.txt", 20), "/very/lo.../name.txt"); // Fixed expectation
    test:assertEquals(truncateMiddle("short", 20), "short");
    test:assertEquals(truncateMiddle("test", 3), "tes"); // Fixed expectation
}
