# @approov/rfc8941_sfv

[English](README.md) | 中文

一个无第三方依赖的 ArkTS 实现，基于 [RFC 9651 Structured Field Values for HTTP](https://www.rfc-editor.org/rfc/rfc9651)（RFC 8941 的修订版），并使用 [httpwg/structured-field-tests](https://github.com/httpwg/structured-field-tests) 测试套件进行了验证。

Structured Field Values（结构化字段值，简称 SFV）是 IETF 为 HTTP 头部/尾部字段定义的一套通用数据结构（Item、List、Dictionary 等），常用于 Signature、Signature-Input（HTTP Message Signatures）等场景的头部解析与序列化。本库提供了对该规范的完整解析（Parse）与序列化（Serialize）实现。

## 下载安装

```
ohpm install @approov/rfc8941_sfv
```

OpenHarmony ohpm 环境变量配置等更多内容，请参考 [如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## 使用说明

### 解析（Parse）

```typescript
import { parseDictionary, parseList, parseItem } from '@approov/rfc8941_sfv';

// 解析 Dictionary，例如 HTTP 头 `Example-Dict: a=1, b=2;x=?0, c`
const dict = parseDictionary('a=1, b=2;x=?0, c');
console.log(dict.get('a')?.get()); // 1

// 解析 List，例如 HTTP 头 `Example-List: "foo", "bar", "It was the best of times."`
const list = parseList('"foo", "bar", "It was the best of times."');

// 解析单个 Item，例如 HTTP 头 `Example-Item: 5; foo=bar`
const item = parseItem('5; foo=bar');
```

也可以直接使用 `Parser` 类，并传入一个数组以支持多行同名字段（RFC 9651 §4.2 要求以 `,` 拼接）：

```typescript
import { Parser } from '@approov/rfc8941_sfv';

const parser = new Parser(['sig1=:MTIzNDU2Nzg5,', ':MjM0NTY3ODk=:']);
const dict = parser.parseDictionary();
```

### 序列化（Serialize）

每个可序列化的类型（`SfvList`、`Dictionary`、各 `*Item`）都提供 `serialize()` 方法，返回可直接写入 HTTP 头字段值的字符串：

```typescript
import { Dictionary, IntegerItem, SfvParameters } from '@approov/rfc8941_sfv';

const dict = new Dictionary();
dict.set('a', new IntegerItem(1, new SfvParameters()));
console.log(dict.serialize()); // "a=1"
```

### 构建 Item / Parameters

```typescript
import {
  BooleanItem, IntegerItem, DecimalItem, DateItem,
  StringItem, TokenItem, ByteSequenceItem, DisplayStringItem,
  InnerList, SfvParameters,
} from '@approov/rfc8941_sfv';

const params = new SfvParameters();
params.set('foo', new TokenItem('bar', new SfvParameters()));

const item = new IntegerItem(5, params);
console.log(item.serialize()); // "5;foo=bar"
```

### 错误处理

解析失败时会抛出 `ParseError`（及其子类 `ItemParseError`、`ParameterError` 等），可按需捕获：

```typescript
import { parseItem, ParseError } from '@approov/rfc8941_sfv';

try {
  parseItem('not a valid sfv item ??');
} catch (e) {
  if (e instanceof ParseError) {
    console.error(`SFV 解析失败: ${e.message}`);
  }
}
```

## 接口说明

| 类型 / 函数 | 说明 |
| --- | --- |
| `parseDictionary(input: string \| string[])` | 解析为 `Dictionary`（RFC 9651 §4.2.2） |
| `parseList(input: string \| string[])` | 解析为 `SfvList`（RFC 9651 §4.2.1） |
| `parseItem(input: string \| string[])` | 解析为单个 `ItemType`（RFC 9651 §4.2.3） |
| `Parser` | 底层解析器，`parseDictionary()` / `parseList()` / `parseItem()` 实例方法 |
| `Dictionary` / `SfvList` / `InnerList` | 容器类型，均提供 `serialize()` |
| `BooleanItem` / `IntegerItem` / `DecimalItem` / `DateItem` / `StringItem` / `TokenItem` / `ByteSequenceItem` / `DisplayStringItem` | 八种 Item 类型，均提供 `get()` / `getParams()` / `serialize()` |
| `SfvParameters` | Item/InnerList 上的参数集合 |
| `HttpHeaderUtils` | 内部字符集/Base64/UTF-8 等校验与编解码工具方法 |
| `ParseError` / `ItemParseError` / `ParameterError` 等 | 解析/校验失败时抛出的错误类型 |

完整导出列表见 [Index.ets](Index.ets)。

## 关于混淆

如果使用了本库，在混淆的时候需要添加相应的保留规则，混淆配置请参考[混淆规则说明](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/source-obfuscation)。

本库已在自身的 [obfuscation-rules.txt](approov_rfc8941_sfv/obfuscation-rules.txt) 中开启了属性混淆、顶层作用域混淆、文件名混淆及导出混淆；由于本库对外仅通过 [Index.ets](Index.ets) 暴露公共 API，消费方工程一般无需额外配置即可正常使用。若在混淆后调用本库接口出现异常（例如反射访问了被混淆的属性名），可在工程的 `obfuscation-rules.txt` 中添加类似如下的保留规则：

```
-keep
./oh_modules/@approov/rfc8941_sfv
```

## 约束与限制

- 本库基于 ArkTS 编写，适用于 HarmonyOS/OpenHarmony Stage 模型工程。
- 兼容 API Version：与本仓库根工程 [build-profile.json5](build-profile.json5) 中声明的 `compatibleSdkVersion` 保持一致（当前为 6.0.1(21)）。
- 支持设备类型：default、tablet、car、wearable。

## 目录结构

```
approov_rfc8941_sfv
├── Index.ets                  # 对外导出入口
├── src
│   └── main
│       └── ets
│           ├── sfv/           # Item / List / Dictionary / Parser 等核心实现
│           ├── error/         # 解析与参数错误类型
│           └── utils/         # 序列化与 HTTP 头部工具函数
└── obfuscation-rules.txt      # 混淆规则配置
```

## 测试

本库通过 [httpwg/structured-field-tests](https://github.com/httpwg/structured-field-tests) 测试套件进行验证——这是 IETF HTTP 工作组为 RFC 8941/9651 结构化字段值维护的、供各语言实现共用的测试集。[entry/src/ohosTest/ets/test](entry/src/ohosTest/ets/test) 下的 `ohosTest` 模块将该测试套件的 JSON 用例移植为 ArkTS 测试数据（见 `sft-data/` 目录），并通过 [SftHarness.ets](entry/src/ohosTest/ets/test/SftHarness.ets) 对每条用例做解析→序列化的往返校验。

## 贡献代码

欢迎通过 Issue / Pull Request 参与本项目的开发。

## 开源协议

本项目基于 MIT License 开源，详见 [approov_rfc8941_sfv/oh-package.json5](approov_rfc8941_sfv/oh-package.json5) 中的 `license` 字段。
