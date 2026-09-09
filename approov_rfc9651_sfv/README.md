# @approov/rfc9651-sfv

English | [中文](readme-cn)

Repository: [https://github.com/approov/rfc8941-sfv-hos](https://github.com/approov/rfc8941-sfv-hos)

A dependency-free ArkTS implementation of [RFC 9651 Structured Field Values for HTTP](https://www.rfc-editor.org/rfc/rfc9651) (which revises RFC 8941), verified against the [httpwg/structured-field-tests](https://github.com/httpwg/structured-field-tests) suite.

Structured Field Values (SFV) is a set of common data structures (Item, List, Dictionary, etc.) defined by the IETF for HTTP header/trailer fields, commonly used when parsing and serializing headers such as `Signature` and `Signature-Input` (HTTP Message Signatures). This library provides a complete parser and serializer for the specification.

## Installation

```
ohpm install @approov/rfc9651-sfv
```

For more on setting up the OpenHarmony ohpm environment, see [How to install an OpenHarmony ohpm package](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md).

## Usage

### Parsing

```typescript
import { parseDictionary, parseList, parseItem } from '@approov/rfc9651-sfv';

// Parse a Dictionary, e.g. the HTTP header `Example-Dict: a=1, b=2;x=?0, c`
const dict = parseDictionary('a=1, b=2;x=?0, c');
console.log(dict.get().get('a')?.get()); // 1

// Parse a List, e.g. the HTTP header `Example-List: "foo", "bar", "It was the best of times."`
const list = parseList('"foo", "bar", "It was the best of times."');

// Parse a single Item, e.g. the HTTP header `Example-Item: 5; foo=bar`
const item = parseItem('5; foo=bar');
```

You can also use the `Parser` class directly, passing an array to support multiple field lines with the same name (RFC 9651 §4.2 requires joining them with `,`):

```typescript
import { Parser } from '@approov/rfc9651-sfv';

const parser = new Parser(['sig1=:MTIzNDU2Nzg5,', ':MjM0NTY3ODk=:']);
const dict = parser.parseDictionary();
```

### Serializing

Every serializable type (`SfvList`, `Dictionary`, and each `*Item`) provides a `serialize()` method that returns a string ready to be written as an HTTP header field value:

```typescript
import { Dictionary, IntegerItem } from '@approov/rfc9651-sfv';

const dict = Dictionary.valueOf(new Map([
  ['a', IntegerItem.valueOf(1)],
]));
console.log(dict.serialize()); // "a=1"
```

### Building Items / Parameters

```typescript
import { IntegerItem, TokenItem, SfvParameters } from '@approov/rfc9651-sfv';

const params = SfvParameters.EMPTY.add('foo', TokenItem.valueOf('bar'));
const item = IntegerItem.valueOf(5).withParams(params);
console.log(item.serialize()); // "5;foo=bar"
```

### Error handling

Parsing failures throw a `ParseError` (or one of its subclasses, such as `ItemParseError` or `ParameterError`), which you can catch as needed:

```typescript
import { parseItem, ParseError } from '@approov/rfc9651-sfv';

try {
  parseItem('not a valid sfv item ??');
} catch (e) {
  if (e instanceof ParseError) {
    console.error(`Failed to parse SFV: ${e.message}`);
  }
}
```

## API

| Type / Function | Description |
| --- | --- |
| `parseDictionary(input: string \| string[])` | Parses a `Dictionary` (RFC 9651 §4.2.2) |
| `parseList(input: string \| string[])` | Parses an `SfvList` (RFC 9651 §4.2.1) |
| `parseItem(input: string \| string[])` | Parses a single `ItemType` (RFC 9651 §4.2.3) |
| `Parser` | Low-level parser with `parseDictionary()` / `parseList()` / `parseItem()` instance methods |
| `Dictionary` / `SfvList` / `InnerList` | Container types, each providing `serialize()` |
| `BooleanItem` / `IntegerItem` / `DecimalItem` / `DateItem` / `StringItem` / `TokenItem` / `ByteSequenceItem` / `DisplayStringItem` | The eight Item types, each providing `get()` / `getParams()` / `serialize()` |
| `SfvParameters` | Parameter collection attached to an Item or InnerList |
| `HttpHeaderUtils` | Internal charset/Base64/UTF-8 validation and encode/decode helpers |
| `ParseError` / `ItemParseError` / `ParameterError`, etc. | Error types thrown on parse/validation failure |

See [Index.ets](Index.ets) for the full list of exports.

## Obfuscation

If you use this library, add the corresponding keep rules when obfuscating your app. See [Code Obfuscation](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/source-obfuscation) for details.

This library's own [obfuscation-rules.txt](approov_rfc9651_sfv/obfuscation-rules.txt) already enables property obfuscation, top-level obfuscation, filename obfuscation, and export obfuscation. Since the library only exposes its public API through [Index.ets](Index.ets), consuming projects generally need no extra configuration. If calling into this library after obfuscation causes issues (for example, reflective access to an obfuscated property name), add a keep rule like the following to your project's `obfuscation-rules.txt`:

```
-keep
./oh_modules/@approov/rfc9651-sfv
```

## Constraints and limitations

- Written in ArkTS, for use in HarmonyOS/OpenHarmony Stage-model projects.
- Compatible API version: matches the `compatibleSdkVersion` declared in this repo's root [build-profile.json5](build-profile.json5) (currently 6.0.1(21)).
- Supported device types: default, tablet, car, wearable.

## Directory structure

```
approov_rfc9651_sfv
├── Index.ets                  # Public export entry point
├── src
│   └── main
│       └── ets
│           ├── sfv/           # Item / List / Dictionary / Parser core implementation
│           ├── error/         # Parse and parameter error types
│           └── utils/         # Serialization and HTTP header helper functions
└── obfuscation-rules.txt      # Obfuscation rules
```

## Testing

This library is verified against the [httpwg/structured-field-tests](https://github.com/httpwg/structured-field-tests) suite — the shared, cross-implementation test corpus maintained by the IETF HTTP Working Group for RFC 8941/9651 Structured Field Values. The `ohosTest` module under [entry/src/ohosTest/ets/test](entry/src/ohosTest/ets/test) ports that suite's JSON test cases into ArkTS fixtures (see `sft-data/`) and runs them via [SftHarness.ets](entry/src/ohosTest/ets/test/SftHarness.ets), which round-trips each case through this library's parser and serializer.

## Contributing

Issues and pull requests are welcome.

## License

This project is licensed under the MIT License; see the `license` field in [approov_rfc9651_sfv/oh-package.json5](approov_rfc9651_sfv/oh-package.json5).
