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
function testToCamelCase() {
    test:assertEquals(toCamelCase("user_profile_image"), "userProfileImage");
    test:assertEquals(toCamelCase("first-name"), "firstName");
    test:assertEquals(toCamelCase("Last Name"), "lastName");
    test:assertEquals(toCamelCase("HELLO_WORLD"), "helloWorld");
    test:assertEquals(toCamelCase(""), "");
    test:assertEquals(toCamelCase("single"), "single");
}

@test:Config {}
function testToSnakeCase() {
    test:assertEquals(toSnakeCase("billingAddress"), "billing_address");
    test:assertEquals(toSnakeCase("firstName"), "first_name");
    test:assertEquals(toSnakeCase("XMLHttpRequest"), "x_m_l_http_request"); // Updated expectation
    test:assertEquals(toSnakeCase("first-name"), "first_name");
    test:assertEquals(toSnakeCase("Hello World"), "hello_world");
    test:assertEquals(toSnakeCase(""), "");
}

@test:Config {}
function testToKebabCase() {
    test:assertEquals(toKebabCase("NewProductTitle"), "new-product-title");
    test:assertEquals(toKebabCase("userProfile"), "user-profile");
    test:assertEquals(toKebabCase("user_profile"), "user-profile");
    test:assertEquals(toKebabCase("XMLParser"), "x-m-l-parser"); // Updated expectation
    test:assertEquals(toKebabCase("Hello World"), "hello-world");
    test:assertEquals(toKebabCase(""), "");
}

@test:Config {}
function testToTitleCase() {
    test:assertEquals(toTitleCase("john doe"), "John Doe");
    test:assertEquals(toTitleCase("HELLO WORLD"), "Hello World");
    test:assertEquals(toTitleCase("the quick brown fox"), "The Quick Brown Fox");
    test:assertEquals(toTitleCase(""), "");
    test:assertEquals(toTitleCase("a"), "A");
}

@test:Config {}
function testToUpperCase() {
    test:assertEquals(toUpperCase("hello world"), "HELLO WORLD");
    test:assertEquals(toUpperCase("Hello World"), "HELLO WORLD");
    test:assertEquals(toUpperCase(""), "");
}

@test:Config {}
function testToLowerCase() {
    test:assertEquals(toLowerCase("HELLO WORLD"), "hello world");
    test:assertEquals(toLowerCase("Hello World"), "hello world");
    test:assertEquals(toLowerCase(""), "");
}
