# Strings - Comprehensive String Utilities for Ballerina

Strings is a comprehensive string utility module for Ballerina that provides powerful, real-world functionality for string manipulation, cleaning, formatting, and processing. Built with modern application development in mind, this module offers an intuitive and extensive API for common string operations.

**🎯 Implementation Status: Core functionality complete**
All essential string manipulation features implemented with 43 passing tests

---

**Strings** - Making string manipulation simple, powerful, and intuitive in Ballerina! 🔤✨

---

## 🚀 Key Features

- **🔄 Case Transformations**: Convert between camelCase, snake_case, kebab-case, Title Case, and more
- **🧼 Cleaning & Sanitization**: Powerful text cleaning, whitespace handling, and character filtering
- **📏 Padding & Truncation**: Smart padding and truncation with multiple strategies
- **🛡️ Safe Operations**: Null-safe string operations with sensible defaults
- **🤖 AI/LLM Ready**: Masking, redaction, and token-aware truncation for modern AI workflows
- **⚡ Performance**: Efficient implementations with comprehensive test coverage (43 passing tests)
- **🎯 Developer Experience**: Intuitive APIs with extensive options and configurations

## 📦 Usage

Import `commons/strings` in your code.

```ballerina
import commons/strings;
```

## 🎯 Quick Start

```ballerina
import commons/strings;

public function main() {
    // Case transformations
    string camelCase = strings:toCamelCase("user_profile_image"); // "userProfileImage"
    string snakeCase = strings:toSnakeCase("billingAddress"); // "billing_address"
    string kebabCase = strings:toKebabCase("NewProductTitle"); // "new-product-title"
    string titleCase = strings:toTitleCase("john doe"); // "John Doe"

    // Cleaning and sanitization
    string clean = strings:trimAndClean("  hello    world  "); // "hello world"
    string numeric = strings:removeNonNumeric("ID-98765-A"); // "98765"
    string normalized = strings:normalize("JOSÉ Niño"); // "jose nino"

    // Padding and truncation
    string padded = strings:padLeft("45", 5, "0"); // "00045"
    string truncated = strings:truncate("This is a very long description", 20); // "This is a very lo..."

    // Safe operations
    string safe = strings:defaultIfEmpty((), "default"); // "default"
    string first = strings:firstNonEmpty((), "", "first", "second"); // "first"
    string domain = strings:substringAfter("user@google.com", "@"); // "google.com"

    // AI/LLM ready functions
    string masked = strings:mask("1234-5678-9012-3456", 4, 4); // "1234-****-****-3456"
    string tokenTruncated = strings:truncateByToken("Very long text...", 50);
    string redacted = strings:redactSensitiveInfo("My SSN is 123-45-6789");
    // Result: "My SSN is XXX-XX-XXXX"
}
```

## 📚 Core Functionalities

### 🔄 Case and Format Transformations

Convert between different naming conventions and text formats:

```ballerina
// Convert from various formats to camelCase
string camel1 = strings:toCamelCase("user_profile_image"); // "userProfileImage"
string camel2 = strings:toCamelCase("first-name"); // "firstName"
string camel3 = strings:toCamelCase("Last Name"); // "lastName"

// Convert to snake_case for database columns
string snake1 = strings:toSnakeCase("billingAddress"); // "billing_address"
string snake2 = strings:toSnakeCase("first-name"); // "first_name"

// Convert to kebab-case for URLs
string kebab1 = strings:toKebabCase("NewProductTitle"); // "new-product-title"
string kebab2 = strings:toKebabCase("user_profile"); // "user-profile"

// Format for display
string title = strings:toTitleCase("john doe smith"); // "John Doe Smith"
string upper = strings:toUpperCase("hello world"); // "HELLO WORLD"
string lower = strings:toLowerCase("HELLO WORLD"); // "hello world"

// Test examples from actual test suite:
// test:assertEquals(toCamelCase("user_profile_image"), "userProfileImage");
// test:assertEquals(toSnakeCase("billingAddress"), "billing_address");
// test:assertEquals(toKebabCase("NewProductTitle"), "new-product-title");
// test:assertEquals(toTitleCase("john doe"), "John Doe");
```

### 🧼 Cleaning and Sanitization

Clean and sanitize input data from external systems:

```ballerina
// Clean whitespace and normalize spacing
string clean = strings:trimAndClean("  hello    world  "); // "hello world"

// Extract specific character types
string numeric = strings:removeNonNumeric("Order: (123)-456"); // "123456"
string alpha = strings:removeNonAlpha("John123Doe456"); // "JohnDoe"
string alphaNum = strings:removeNonAlphanumeric("Hello, World! 123"); // "HelloWorld123"

// Remove specific characters
string noSpaces = strings:removeWhitespace("Hello World"); // "HelloWorld"
string cleaned = strings:removeChars("Hello-World!", "-!"); // "HelloWorld"

// Advanced normalization
string normalized = strings:normalize("JOSÉ Niño"); // "jose nino"

// Custom normalization options
string customNorm = strings:normalize("  JOSÉ  Niño  ", {
    lowercase: true,
    trim: true
}); // "jose nino"

// Test examples from actual test suite:
// test:assertEquals(trimAndClean("  hello    world  "), "hello world");
// test:assertEquals(removeNonNumeric("ID-98765-A"), "98765");
// test:assertEquals(removeNonAlpha("John123Doe456"), "JohnDoe");
```

### 📏 Padding and Truncating

Format strings for fixed-width fields and length constraints:

```ballerina
// Basic padding
string leftPad = strings:padLeft("45", 5, "0"); // "00045"
string rightPad = strings:padRight("Apple", 10, " "); // "Apple     "
string centerPad = strings:padCenter("Hi", 6, "*"); // "**Hi**"

// Advanced padding with options
string padded = strings:pad("text", {
    length: 10,
    truncate: true
}); // "text------"

// Basic truncation
string truncated = strings:truncate("This is a very long description", 20); // "This is a very lo..."

// Word-boundary truncation
string wordTrunc = strings:truncateWords("This is a very long description", 20); // "This is a very..."

// Middle truncation for paths/URLs
string middleTrunc = strings:truncateMiddle("/very/long/file/path/name.txt", 20); // "/very/lo.../name.txt"

// Advanced truncation with options
string advTrunc = strings:truncateAdvanced("Long text here", {
    maxLength: 10,
    preserveWords: true
}); // "Long text…"

// Test examples from actual test suite:
// test:assertEquals(padLeft("45", 5, "0"), "00045");
// test:assertEquals(padRight("Apple", 10, " "), "Apple     ");
// test:assertEquals(truncate("This is a very long description", 20), "This is a very lo...");
```

### 🛡️ Safe Operations and Defaults

Handle null and empty values gracefully:
string cleaned = strings:removeChars("Hello-World!", "-!"); // "HelloWorld"

// Advanced normalization
string normalized = strings:normalize("JOSÉ Niño"); // "jose nino"

// Custom normalization options
string customNorm = strings:normalize("  JOSÉ  Niño  ", {
    lowercase: true,
    removeDiacritics: true,
    collapseWhitespace: true,
    trim: true
}); // "jose nino"
```

### 🤖 LLM and AI-Ready Functions

Prepare data for AI/ML processing and protect sensitive information:

```ballerina
// Basic masking
string masked = strings:mask("1234-5678-9012-3456", 4, 4); // "1234-****-****-3456"

// Advanced masking with options
string maskedAdv = strings:maskAdvanced("sensitive-data", {
    visibleStart: 2,
    visibleEnd: 2,
    maskChar: "#",
    minLength: 5
}); // "se#######ta"

// Specialized masking functions
string maskedEmail = strings:maskEmail("john.doe@company.com"); // "j*****e@company.com"
string maskedPhone = strings:maskPhone("(555) 123-4567"); // "(555) ***-**67"
string maskedCard = strings:maskCreditCard("4532-1234-5678-9012"); // "4532-****-****-9012"

// Token-aware truncation for LLMs
string tokenTrunc = strings:truncateByToken("This is a very long text that might exceed token limits for AI processing", 10);
// Result: "This is a very long text that might exceed..."

// Estimate token count
int tokens = strings:estimateTokens("Hello world, how are you?"); // Approximate token count

// Redact sensitive information automatically
string original = "Contact John at john@email.com or call 555-123-4567. SSN: 123-45-6789";
string redacted = strings:redactSensitiveInfo(original);
// Result: "Contact John at XXXXX@XXXXXXXX.com or call XXX-XXX-XX67. SSN: XXXXXXXXXXX"
```

## 🧪 Testing

Strings includes comprehensive testing covering:

- **Case transformations** - All conversion scenarios
- **Cleaning operations** - Various input formats and edge cases
- **Padding and truncation** - Different strategies and options
- **Safe operations** - Null handling and default values
- **AI functions** - Masking and redaction accuracy
- **Edge cases** - Empty strings, null values, special characters
- **Integration testing** - Cross-function compatibility

Run tests:
```bash
bal test
```

## 🔧 Configuration and Options

The Strings module provides extensive configuration options through various record types and enums to customize function behavior.

### Enums

#### Case Types
```ballerina
public enum CaseType {
    CAMEL = "camel",     // firstName
    SNAKE = "snake",     // first_name  
    KEBAB = "kebab",     // first-name
    TITLE = "title",     // First Name
    UPPER = "upper",     // FIRST NAME
    LOWER = "lower"      // first name
}
```

#### Padding Direction
```ballerina
public enum PadDirection {
    LEFT = "left",       // Pad on the left side
    RIGHT = "right",     // Pad on the right side
    CENTER = "center"    // Pad on both sides (center)
}
```

#### Truncation Strategy
```ballerina
public enum TruncationStrategy {
    END = "end",         // Truncate at the end with suffix
    MIDDLE = "middle",   // Truncate in the middle with suffix
    WORD = "word"        // Truncate at word boundary
}
```

#### Character Categories
```ballerina
public enum CharacterCategory {
    ALPHA = "alpha",           // Alphabetic characters (a-z, A-Z)
    NUMERIC = "numeric",       // Numeric characters (0-9)
    ALPHANUMERIC = "alphanumeric", // Alphanumeric characters
    WHITESPACE = "whitespace", // Whitespace characters
    SPECIAL = "special"        // Special/symbol characters
}
```

### Configuration Records

#### Basic Options

```ballerina
// Padding options
PaddingOptions paddingOpts = {
    length: 20,                    // Total length after padding
    padChar: "-",                  // Character to use for padding
    direction: strings:CENTER,     // Padding direction
    truncate: true                 // Truncate if string is longer
};

// Truncation options  
TruncationOptions truncOpts = {
    maxLength: 100,                // Maximum length of result
    suffix: "…",                   // Suffix to append when truncating
    strategy: strings:WORD,        // Truncation strategy
    preserveWords: true            // Preserve word boundaries
};

// Normalization options
NormalizationOptions normOpts = {
    lowercase: true,               // Convert to lowercase
    removeDiacritics: true,        // Remove diacritics/accents
    collapseWhitespace: true,      // Collapse multiple whitespace
    trim: true                     // Trim leading/trailing whitespace
};
```

#### Masking Options

```ballerina
// Basic masking options
MaskOptions maskOpts = {
    visibleStart: 3,               // Characters visible at start
    visibleEnd: 3,                 // Characters visible at end
    maskChar: "*",                 // Character to use for masking
    minLength: 6                   // Minimum length before masking
};

// Email masking options
EmailMaskOptions emailOpts = {
    localVisibleStart: 2,          // Visible chars at start of local part
    localVisibleEnd: 1,            // Visible chars at end of local part
    maskDomain: false,             // Whether to mask domain
    domainVisibleStart: 1,         // Visible chars at start of domain
    domainVisibleEnd: 3,           // Visible chars at end of domain
    maskChar: "*",                 // Masking character
    minLocalLength: 3,             // Min local part length to mask
    minDomainLength: 5,            // Min domain length to mask
    domainExtensionMask: "***"     // Domain extension replacement
};

// Phone masking options
PhoneMaskOptions phoneOpts = {
    visibleStart: 3,               // Visible digits at start
    visibleEnd: 4,                 // Visible digits at end
    maskChar: "*",                 // Masking character
    preserveFormatting: true,      // Keep brackets, spaces, hyphens
    minLength: 10                  // Minimum length before masking
};

// Credit card masking options
CreditCardMaskOptions cardOpts = {
    visibleStart: 4,               // Visible digits at start
    visibleEnd: 4,                 // Visible digits at end
    maskChar: "*",                 // Masking character
    groupDigits: true,             // Group with hyphens/spaces
    minLength: 13                  // Minimum length before masking
};
```

### Usage Examples with Options

```ballerina
// Using padding options
string padded = strings:pad("text", {
    length: 15,
    padChar: "=",
    direction: strings:CENTER,
    truncate: false
}); // "=====text====="

// Using truncation options
string truncated = strings:truncateAdvanced("This is a very long sentence", {
    maxLength: 20,
    suffix: "...",
    strategy: strings:WORD,
    preserveWords: true
}); // "This is a very..."

// Using normalization options
string normalized = strings:normalize("  JOSÉ María  ", {
    lowercase: true,
    removeDiacritics: true,
    collapseWhitespace: true,
    trim: true
}); // "jose maria"

// Using advanced masking
string masked = strings:maskEmail("john.doe@company.com", {
    localVisibleStart: 1,
    localVisibleEnd: 1,
    maskDomain: true,
    maskChar: "#"
}); // "j######e@c#####y.###"
```

## 🤝 Contributing

We welcome contributions! Please see our [design.md](./design.md) for implementation details and architecture overview.

### Development Setup
```bash
git clone https://github.com/bal-tips/module-commons-strings.git
cd module-commons-strings
bal build
bal test
```

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](./LICENSE) file for details.

## 📝 About Module

### Vision
To provide the most comprehensive, intuitive, and powerful string manipulation utilities for the Ballerina ecosystem, enabling developers to handle text processing with confidence and efficiency.

### Purpose
Strings addresses the common need for robust string manipulation in modern applications, from simple case conversions to AI-ready text processing and sensitive data masking. This module empowers developers with production-ready tools for handling text in real-world scenarios.

### Attribution
Created and maintained by [Hasitha Aravinda](https://github.com/hasithaa)

## 🔗 Related Projects

- [ballerina-lang](https://github.com/ballerina-platform/ballerina-lang) - The Ballerina programming language

## 📞 Support

- **Documentation**: See [design.md](./design.md) for detailed documentation
- **Issues**: Report bugs and request features via GitHub Issues

---

**Note:** Ballerina is a registered trademark of WSO2 LLC.
