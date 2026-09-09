import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import { ParseError } from '../error/ParseError';
import { SfvParameters, ItemType } from './SfvParameters';
import { BooleanItem } from './BooleanItem';
import { IntegerItem } from './IntegerItem';
import { DecimalItem } from './DecimalItem';
import { DateItem } from './DateItem';
import { StringItem } from './StringItem';
import { TokenItem } from './TokenItem';
import { ByteSequenceItem } from './ByteSequenceItem';
import { DisplayStringItem } from './DisplayStringItem';
import { InnerList } from './InnerList';
import { SfvList } from './SfvList';
import { Dictionary } from './Dictionary';
import { ListElement } from './ListElement';

const EOF = '￿'; // sentinel for end-of-input

/**
 * Implementation of the Structured Field Values Parser (RFC 8941 Section 4.2).
 */
export class Parser {
  private input: string;
  private pos: number = 0;
  private readonly startPositions: number[];

  constructor(input: string | string[]) {
    if (typeof input === 'string') {
      this.input = checkASCII(input);
      this.startPositions = [];
    } else {
      // Multiple field lines: join with ','
      const fieldLines = input as string[];
      if (fieldLines.length === 0) {
        throw new ParseError('Empty input', '', 0);
      }
      const startPositions: number[] = [];
      let combined = '';
      let first = true;
      for (const line of fieldLines) {
        if (line === null || line === undefined) {
          throw new ParseError('field line must not be null', '', 0);
        }
        const ascii = checkASCII(line);
        if (!first) {
          startPositions.push(combined.length);
          combined += ',';
        }
        combined += ascii;
        first = false;
      }
      this.input = combined;
      this.startPositions = startPositions;
    }
  }

  // ─── Public instance parse methods ───────────────────────────────────────

  /** Parse a List (RFC 8941 Section 4.2.1). */
  parseList(): SfvList {
    this.skipSP();
    const result = this.parseOuterListInternal();
    this.skipSP();
    this.assertEmpty('Extra characters in string parsed as List');
    return SfvList.valueOf(result);
  }

  /** Parse a Dictionary (RFC 8941 Section 4.2.2). */
  parseDictionary(): Dictionary {
    this.skipSP();
    const result = this.parseDictionaryInternal();
    this.skipSP();
    this.assertEmpty('Extra characters in string parsed as Dictionary');
    return result;
  }

  /** Parse an Item (RFC 8941 Section 4.2.3). */
  parseItem(): ItemType {
    this.skipSP();
    const result = this.parseItemInternal();
    this.skipSP();
    this.assertEmpty('Extra characters in string parsed as Item');
    return result;
  }

  // ─── Public static convenience methods ───────────────────────────────────

  static parseBareItem(input: string): ItemType {
    const p = new Parser(input);
    const result = p.parseBareItemInternal();
    p.assertEmpty('Extra characters in string parsed as Bare Item');
    return result;
  }

  static parseItemOrInnerList(input: string): ListElement {
    const p = new Parser(input);
    const result = p.parseItemOrInnerListInternal();
    p.assertEmpty('Extra characters in string parsed as Item or Inner List');
    return result;
  }

  static parseInnerList(input: string): InnerList {
    const p = new Parser(input);
    const result = p.parseInnerListInternal();
    p.assertEmpty('Extra characters in string parsed as Inner List');
    return result;
  }

  static parseParameters(input: string): SfvParameters {
    const p = new Parser(input);
    const result = p.parseParametersInternal();
    p.assertEmpty('Extra characters in string parsed as SfvParameters');
    return result;
  }

  static parseKey(input: string): string {
    const p = new Parser(input);
    const result = p.parseKeyInternal();
    p.assertEmpty('Extra characters in string parsed as Key');
    return result;
  }

  static parseIntegerOrDecimal(input: string): IntegerItem | DecimalItem {
    const p = new Parser(input);
    const result = p.parseIntegerOrDecimalInternal();
    p.assertEmpty('Extra characters in string parsed as Integer or Decimal');
    return result;
  }

  static parseInteger(input: string): IntegerItem {
    const p = new Parser(input);
    const result = p.parseIntegerOrDecimalInternal();
    if (!(result instanceof IntegerItem)) {
      throw p.complaint(`String parsed as Integer '${input}' is a Decimal`);
    }
    p.assertEmpty('Extra characters in string parsed as Integer');
    return result as IntegerItem;
  }

  static parseDecimal(input: string): DecimalItem {
    const p = new Parser(input);
    const result = p.parseIntegerOrDecimalInternal();
    if (!(result instanceof DecimalItem)) {
      throw p.complaint(`String parsed as Decimal '${input}' is an Integer`);
    }
    p.assertEmpty('Extra characters in string parsed as Decimal');
    return result as DecimalItem;
  }

  static parseString(input: string): StringItem {
    const p = new Parser(input);
    const result = p.parseStringInternal();
    p.assertEmpty('Extra characters in string parsed as String');
    return result;
  }

  static parseToken(input: string): TokenItem {
    const p = new Parser(input);
    const result = p.parseTokenInternal();
    p.assertEmpty('Extra characters in string parsed as Token');
    return result;
  }

  static parseByteSequence(input: string): ByteSequenceItem {
    const p = new Parser(input);
    const result = p.parseByteSequenceInternal();
    p.assertEmpty('Extra characters in string parsed as Byte Sequence');
    return result;
  }

  static parseBoolean(input: string): BooleanItem {
    const p = new Parser(input);
    const result = p.parseBooleanInternal();
    p.assertEmpty('Extra characters in string parsed as Boolean');
    return result;
  }

  static parseDate(input: string): DateItem {
    const p = new Parser(input);
    const result = p.parseDateInternal();
    p.assertEmpty('Extra characters in string parsed as Date');
    return result;
  }

  static parseDisplayString(input: string): DisplayStringItem {
    const p = new Parser(input);
    const result = p.parseDisplayStringInternal();
    p.assertEmpty('Extra characters in string parsed as Display String');
    return result;
  }

  // ─── Internal parse methods ───────────────────────────────────────────────

  private parseDateBareInternal(): DateItem {
    if (this.peek() !== '@') {
      throw this.complaint(`Illegal start for Date: '${this.rawString()}'`);
    }
    this.advance();

    let sign = 1;
    if (this.peek() === '-') {
      sign = -1;
      this.advance();
    }

    if (!HttpHeaderUtils.isDigit(this.peek())) {
      throw this.complaint(`Illegal start inside a Date: '${this.rawString()}'`);
    }

    let numStr = '';
    while (this.hasRemaining()) {
      const c = this.peek();
      if (HttpHeaderUtils.isDigit(c)) {
        numStr += c;
        this.advance();
      } else {
        break;
      }
      if (numStr.length > 15) {
        this.back();
        throw this.complaint(`Date too long: ${numStr.length} characters`);
      }
    }

    return DateItem.valueOf(sign * parseInt(numStr, 10));
  }

  private parseDateInternal(): DateItem {
    const result = this.parseDateBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseIntegerOrDecimalBareInternal(): IntegerItem | DecimalItem {
    let isDecimal = false;
    let sign = 1;
    let numStr = '';

    if (this.peek() === '-') {
      sign = -1;
      this.advance();
    }

    if (!HttpHeaderUtils.isDigit(this.peek())) {
      throw this.complaint(`Illegal start for Integer or Decimal: '${this.rawString()}'`);
    }

    while (this.hasRemaining()) {
      const c = this.peek();
      if (HttpHeaderUtils.isDigit(c)) {
        numStr += c;
        this.advance();
      } else if (!isDecimal && c === '.') {
        if (numStr.length > 12) {
          throw this.complaint(`Illegal position for decimal point in Decimal after '${numStr}'`);
        }
        numStr += c;
        isDecimal = true;
        this.advance();
      } else {
        break;
      }
      const maxLen = isDecimal ? 16 : 15;
      if (numStr.length > maxLen) {
        this.back();
        throw this.complaint(`${isDecimal ? 'Decimal' : 'Integer'} too long: ${numStr.length} characters`);
      }
    }

    if (!isDecimal) {
      return IntegerItem.valueOf(sign * parseInt(numStr, 10));
    } else {
      const dotPos = numStr.indexOf('.');
      const fracLen = numStr.length - dotPos - 1;

      if (fracLen < 1) {
        this.back();
        throw this.complaint("Decimal must not end in '.'");
      } else if (fracLen > 3) {
        this.back();
        throw this.complaint(`Maximum number of fractional digits is 3, found: ${fracLen}, in: ${numStr}`);
      }

      return DecimalItem.valueOf(sign * Number(numStr));
    }
  }

  private parseIntegerOrDecimalInternal(): IntegerItem | DecimalItem {
    const result = this.parseIntegerOrDecimalBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseStringBareInternal(): StringItem {
    if (this.getOrEOF() !== '"') {
      throw this.complaint(`String must start with double quote: '${this.rawString()}'`);
    }

    let out = '';
    while (this.hasRemaining()) {
      if (this.startPositions.includes(this.position())) {
        throw this.complaint(`String crosses field line boundary at position ${this.position()}`);
      }

      const c = this.get();
      if (c === '\\') {
        const esc = this.getOrEOF();
        if (esc === EOF) {
          throw this.complaint(`Incomplete escape sequence at position ${this.position()}`);
        }
        if (esc !== '"' && esc !== '\\') {
          this.back();
          throw this.complaint(`Invalid escape sequence character '${esc}' at position ${this.position()}`);
        }
        out += esc;
      } else if (c === '"') {
        return StringItem.valueOf(out);
      } else {
        if (!HttpHeaderUtils.isAscii(c)) {
          throw this.complaint(`Invalid character in String at position ${this.position()}`);
        }
        out += c;
      }
    }

    throw this.complaint('Closing DQUOTE missing');
  }

  private parseStringInternal(): StringItem {
    const result = this.parseStringBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseDisplayStringBareInternal(): DisplayStringItem {
    if (this.getOrEOF() !== '%') {
      throw this.complaint(`DisplayString must start with a percent sign: '${this.rawString()}'`);
    }
    if (this.getOrEOF() !== '"') {
      throw this.complaint(`DisplayString must continue with a double quote: '${this.rawString()}'`);
    }

    const bytes: number[] = [];

    while (this.hasRemaining()) {
      if (this.startPositions.includes(this.position())) {
        throw this.complaint(`Display String crosses field line boundary at position ${this.position()}`);
      }

      const c = this.get();
      if (c === '%') {
        const c1 = this.getOrEOF();
        if (c1 === EOF) {
          throw this.complaint(`Incomplete percent escape sequence at position ${this.position()}`);
        }
        if (!HttpHeaderUtils.isHex(c1)) {
          this.back();
          throw this.complaint(`Invalid percent escape sequence character '${c1}' at position ${this.position()}`);
        }
        const c2 = this.getOrEOF();
        if (c2 === EOF) {
          throw this.complaint(`Incomplete percent escape sequence at position ${this.position()}`);
        }
        if (!HttpHeaderUtils.isHex(c2)) {
          this.back();
          throw this.complaint(`Invalid percent escape sequence character '${c2}' at position ${this.position()}`);
        }
        bytes.push(HttpHeaderUtils.decodeHex(c1, c2));
      } else if (c === '"') {
        try {
          const decoded = HttpHeaderUtils.decodeUtf8(new Uint8Array(bytes));
          return DisplayStringItem.valueOf(decoded);
        } catch (e) {
          throw this.complaint(`Invalid UTF-8 sequence: ${(e as Error).message}`, undefined, e as Error);
        }
      } else {
        if (!HttpHeaderUtils.isAscii(c)) {
          throw this.complaint(`Invalid character in Display String at position ${this.position()}`);
        }
        bytes.push(c.charCodeAt(0));
      }
    }

    throw this.complaint('Closing DQUOTE missing');
  }

  private parseDisplayStringInternal(): DisplayStringItem {
    const result = this.parseDisplayStringBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseTokenBareInternal(): TokenItem {
    const c = this.getOrEOF();
    if (c !== '*' && !HttpHeaderUtils.isAlpha(c)) {
      throw this.complaint(`Token must start with ALPHA or *: '${this.rawString()}'`);
    }

    let out = c;
    while (this.hasRemaining()) {
      const next = this.peek();
      if (!HttpHeaderUtils.isTokenChar(next)) {
        break;
      }
      this.advance();
      out += next;
    }

    return TokenItem.valueOf(out);
  }

  private parseTokenInternal(): TokenItem {
    const result = this.parseTokenBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseByteSequenceBareInternal(): ByteSequenceItem {
    if (this.getOrEOF() !== ':') {
      throw this.complaint(`Byte Sequence must start with colon: ${this.rawString()}`);
    }

    let b64 = '';
    let done = false;
    while (this.hasRemaining() && !done) {
      const c = this.get();
      if (c === ':') {
        done = true;
      } else {
        if (!HttpHeaderUtils.isBase64Char(c)) {
          throw this.complaint(`Invalid Byte Sequence Character '${c}' at position ${this.position()}`);
        }
        b64 += c;
      }
    }

    if (!done) {
      throw this.complaint(`Byte Sequence must end with COLON: '${b64}'`);
    }

    try {
      return ByteSequenceItem.valueOf(HttpHeaderUtils.base64Decode(b64));
    } catch (e) {
      throw this.complaint((e as Error).message, undefined, e as Error);
    }
  }

  private parseByteSequenceInternal(): ByteSequenceItem {
    const result = this.parseByteSequenceBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseBooleanBareInternal(): BooleanItem {
    const c = this.getOrEOF();
    if (c === EOF) {
      throw this.complaint('Missing data in Boolean');
    }
    if (c !== '?') {
      this.back();
      throw this.complaint(`Boolean must start with question mark, got '${c}'`);
    }

    const v = this.getOrEOF();
    if (v === EOF) {
      throw this.complaint('Missing data in Boolean');
    }
    if (v !== '0' && v !== '1') {
      this.back();
      throw this.complaint(`Expected '0' or '1' in Boolean, found '${v}'`);
    }

    return BooleanItem.valueOf(v === '1');
  }

  private parseBooleanInternal(): BooleanItem {
    const result = this.parseBooleanBareInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseKeyInternal(): string {
    const c = this.getOrEOF();
    if (c === EOF) {
      throw this.complaint('Missing data in Key');
    }
    if (c !== '*' && !HttpHeaderUtils.isLcAlpha(c)) {
      this.back();
      throw this.complaint(`Key must start with LCALPHA or '*': ${formatChar(c)}`);
    }

    let result = c;
    while (this.hasRemaining()) {
      const next = this.peek();
      if (HttpHeaderUtils.isLcAlpha(next) || HttpHeaderUtils.isDigit(next)
        || next === '_' || next === '-' || next === '.' || next === '*') {
        result += next;
        this.advance();
      } else {
        break;
      }
    }

    return result;
  }

  private parseParametersInternal(): SfvParameters {
    const result = new Map<string, string | number | boolean | Uint8Array | ItemType>();

    while (this.hasRemaining()) {
      if (this.peek() !== ';') {
        break;
      }
      this.advance();
      this.skipSP();
      const name = this.parseKeyInternal();
      let value: string | number | boolean | Uint8Array | ItemType = BooleanItem.valueOf(true);
      if (this.peek() === '=') {
        this.advance();
        value = this.parseBareItemInternal();
      }
      result.set(name, value);
    }

    return SfvParameters.valueOf(result);
  }

  private parseBareItemInternal(): ItemType {
    if (!this.hasRemaining()) {
      throw this.complaint('Empty string found when parsing Bare Item');
    }

    const c = this.peek();
    if (HttpHeaderUtils.isDigit(c) || c === '-') {
      return this.parseIntegerOrDecimalBareInternal();
    } else if (c === '"') {
      return this.parseStringBareInternal();
    } else if (c === '?') {
      return this.parseBooleanBareInternal();
    } else if (c === '*' || HttpHeaderUtils.isAlpha(c)) {
      return this.parseTokenBareInternal();
    } else if (c === ':') {
      return this.parseByteSequenceBareInternal();
    } else if (c === '@') {
      return this.parseDateBareInternal();
    } else if (c === '%') {
      return this.parseDisplayStringBareInternal();
    } else {
      throw this.complaint(`Unexpected start character in Bare Item: ${formatChar(c)}`);
    }
  }

  private parseItemInternal(): ItemType {
    const result = this.parseBareItemInternal();
    const params = this.parseParametersInternal();
    return result.withParams(params);
  }

  private parseItemOrInnerListInternal(): ListElement {
    return this.peek() === '(' ? this.parseInnerListInternal() : this.parseItemInternal();
  }

  private parseOuterListInternal(): ListElement[] {
    const result: ListElement[] = [];

    while (this.hasRemaining()) {
      result.push(this.parseItemOrInnerListInternal());
      this.skipOWS();
      if (!this.hasRemaining()) {
        return result;
      }
      const c = this.get();
      if (c !== ',') {
        this.back();
        throw this.complaint(`Expected COMMA in List, got: ${formatChar(c)}`);
      }
      this.skipOWS();
      if (!this.hasRemaining()) {
        throw this.complaint('Found trailing COMMA in List');
      }
    }

    return result;
  }

  private parseBareInnerListInternal(): ItemType[] {
    const c = this.getOrEOF();
    if (c !== '(') {
      throw this.complaint(`Inner List must start with '(': ${this.rawString()}`);
    }

    const result: ItemType[] = [];
    let done = false;

    while (this.hasRemaining() && !done) {
      this.skipSP();

      const next = this.peek();
      if (next === ')') {
        this.advance();
        done = true;
      } else {
        const item = this.parseItemInternal();
        result.push(item);

        const after = this.peek();
        if (after === EOF) {
          throw this.complaint('Missing data in Inner List');
        }
        if (after !== ' ' && after !== ')') {
          throw this.complaint(`Expected SP or ')' in Inner List, got: ${formatChar(after)}`);
        }
      }
    }

    if (!done) {
      throw this.complaint(`Inner List must end with ')': ${this.rawString()}`);
    }

    return result;
  }

  private parseInnerListInternal(): InnerList {
    const items = this.parseBareInnerListInternal();
    const params = this.parseParametersInternal();
    return InnerList.valueOf(items).withParams(params);
  }

  private parseDictionaryInternal(): Dictionary {
    const result = new Map<string, ListElement>();

    while (this.hasRemaining()) {
      const name = this.parseKeyInternal();
      let member: ListElement;

      if (this.peek() === '=') {
        this.advance();
        member = this.parseItemOrInnerListInternal();
      } else {
        member = BooleanItem.valueOf(true).withParams(this.parseParametersInternal());
      }

      result.set(name, member);

      this.skipOWS();
      if (this.hasRemaining()) {
        const c = this.get();
        if (c !== ',') {
          this.back();
          throw this.complaint(`Expected COMMA in Dictionary, found: ${formatChar(c)}`);
        }
        this.skipOWS();
        if (!this.hasRemaining()) {
          throw this.complaint('Found trailing COMMA in Dictionary');
        }
      }
    }

    return Dictionary.valueOf(result);
  }

  private peek(): string {
    return this.pos < this.input.length ? this.input.charAt(this.pos) : EOF;
  }

  private get(): string {
    const c = this.peek();
    this.pos++;
    return c;
  }

  private advance(): void {
    this.pos++;
  }

  private back(): void {
    this.pos--;
  }

  private hasRemaining(): boolean {
    return this.pos < this.input.length;
  }

  private position(): number {
    return this.pos;
  }

  private rawString(): string {
    return this.input;
  }


  private getOrEOF(): string {
    return this.hasRemaining() ? this.get() : EOF;
  }

  private skipSP(): void {
    while (this.peek() === ' ') {
      this.advance();
    }
  }

  private skipOWS(): void {
    while (this.peek() === ' ' || this.peek() === '\t') {
      this.advance();
    }
  }

  private assertEmpty(message: string): void {
    if (this.hasRemaining()) {
      throw this.complaint(message);
    }
  }

  private complaint(message: string, position?: number, cause?: Error): ParseError {
    return new ParseError(message, this.input, position ?? this.position(), cause);
  }
}


/** Parse a Dictionary (RFC 8941 Section 4.2.2). */
export function parseDictionary(input: string): Dictionary {
  const parser = new Parser(input);
  return parser.parseDictionary();
}

/** Parse a List (RFC 8941 Section 4.2.1). */
export function parseList(input: string): SfvList {
  const parser = new Parser(input);
  return parser.parseList();
}

/** Parse an Item (RFC 8941 Section 4.2.3). */
export function parseItem(input: string): ItemType {
  const parser = new Parser(input);
  return parser.parseItem();
}

// ─── Module-level helpers ─────────────────────────────────────────────────

function checkASCII(value: string): string {
  for (let i = 0; i < value.length; i++) {
    const cp = value.charCodeAt(i);
    if (cp > 0x7f) {
      throw new ParseError(
        `Invalid character in field line at position ${i}: '${value.charAt(i)}' (0x${cp.toString(16).padStart(4, '0')}) (input: ${value})`,
        value, i);
    }
  }
  return value;
}

function formatChar(c: string): string {
  const cp = c.charCodeAt(0);
  const label = c === '\t' ? 'HTAB' : `'${c}'`;
  return `${label} (\\u${cp.toString(16).padStart(4, '0')})`;
}
