import { util } from "@kit.ArkTS";
import { Decimal } from "@kit.ArkTS";
import ItemParseError from '../error/ItemParseError';
import { ParameterKeyParseError } from '../error/ParameterError';

/**
 * Internal utility functions for SFV (RFC 8941).
 *
 */

const ASCII_RE: RegExp = /^[\x20-\x7E]*$/;        // character in String must in between %x20-%x7E
const keyRe: RegExp = /^[a-z*][*\-_.a-z0-9]*$/;   // valid key
const TOKEN_RE: RegExp = /^[a-zA-Z*][:/!#$%&'*+\-.^_`|~A-Za-z0-9]*$/;
const TOKEN_CHAR_RE: RegExp = /^[:/!#$%&'*+\-.^_`|~A-Za-z0-9]$/; // valid token continuation character

const DECIMAL_INTEGER_DIGITS_MAX = 12;

export const NUMBER_MIN : number = -999_999_999_999_999; // the min value in Date/Integer/Decimal items
export const NUMBER_MAX : number = 999_999_999_999_999;  // the max value in Date/Integer/Decimal items

export default class HttpHeaderUtils {
  private constructor() {}

  static isAscii(value: string): boolean {
    return ASCII_RE.test(value);
  }

  static isDigit(c: string): boolean {
    return c >= '0' && c <= '9';
  }

  static isLcAlpha(c: string): boolean {
    return c >= 'a' && c <= 'z';
  }

  static isAlpha(c: string): boolean {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
  }

  static isHex(c: string): boolean {
    return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f');
  }

  static isBase64Char(c: string): boolean {
    return HttpHeaderUtils.isAlpha(c) || HttpHeaderUtils.isDigit(c) || c === '+' || c === '/' || c === '=';
  }

  /** Whether `c` may continue a Token after its first character (RFC 9651 Section 3.3.4). */
  static isTokenChar(c: string): boolean {
    return TOKEN_CHAR_RE.test(c);
  }

  /** Decode two hex digit characters into a byte value. */
  static decodeHex(c1: string, c2: string): number {
    const lookup = '0123456789abcdef';
    return (lookup.indexOf(c1) << 4) | lookup.indexOf(c2);
  }

  static checkKey(value: string): string {
    if (!value || value.length === 0) {
      throw new ParameterKeyParseError('Parameter Key can not be null or empty');
    }
    if (!keyRe.test(value)) {
      throw new ParameterKeyParseError(
        `Invalid Parameter key: '${value}' must start with a lowercase letter or "*", followed by lowercase letters, digits, "_", "-", ".", or "*"`);
    }
    return value;
  }

  static checkKeys(value: Map<string, Object>): Map<string, Object> {
    for (const key of value.keys()) {
      HttpHeaderUtils.checkKey(key);
    }
    return value;
  }

  static checkStringValue(value: string): void {
    if (!HttpHeaderUtils.isAscii(value)) {
      throw new ItemParseError('Parse StringItem Error: String must contain only printable ASCII characters (0x20-0x7E)');
    }
  }

  static checkTokenValue(value: string): void {
    if (!TOKEN_RE.test(value)) {
      throw new ItemParseError(
        'Parse TokenItem Error: Token must start with an alpha character or "*", followed by token characters');
    }
  }

  static checkIntegerValue(value: number): void {
    if (!Number.isInteger(value)) {
      throw new ItemParseError('Parse IntegerItem Error: value must be an integer');
    }
    if (value < NUMBER_MIN || value > NUMBER_MAX) {
      throw new ItemParseError(
        `Parse IntegerItem Error: value must be in the range from ${NUMBER_MIN} to ${NUMBER_MAX}`);
    }
  }

  static checkDateValue(value: number): void {
    if (!Number.isInteger(value)) {
      throw new ItemParseError('Parse DateItem Error: value must be an integer');
    }
    if (value < NUMBER_MIN || value > NUMBER_MAX) {
      throw new ItemParseError(
        `Parse DateItem Error: value must be in the range from ${NUMBER_MIN} to ${NUMBER_MAX}`);
    }
  }

  /**
   * Validates a Decimal bare value (RFC 9651 Section 3.3.2) and returns it already rounded
   * to 3 fractional digits (round-half-to-even), formatted as a fixed-point string. Callers
   * should reuse the returned string rather than calling `toFixed` again themselves.
   */
  static checkDecimalValue(value: number | Decimal): string {
    if (typeof value === 'number' && !Number.isFinite(value)) {
      throw new ItemParseError('Parse DecimalItem Error: value must be a finite number');
    }

    const decimal: Decimal = value instanceof Decimal ? value : new Decimal(value);
    const rounded: string = decimal.toFixed(3, Decimal.ROUND_HALF_EVEN);

    const integerDigits: number = rounded.replace('-', '').split('.')[0].length;
    if (integerDigits > DECIMAL_INTEGER_DIGITS_MAX) {
      throw new ItemParseError(
        `Parse DecimalItem Error: integer component must not exceed ${DECIMAL_INTEGER_DIGITS_MAX} digits`);
    }
    return rounded;
  }

  /** Base64 encode (standard, with padding). An empty array encodes to an empty string. */
  static base64Encode(bytes: Uint8Array): string {
    if (bytes.length === 0) {
      return '';
    }
    return new util.Base64Helper().encodeToStringSync(bytes,util.Type.BASIC)
  }

  /**
   * Decodes a Byte Sequence's base64 content (RFC 9651 Section 4.2.8). An empty string
   * decodes to an empty byte sequence. Missing trailing "=" padding is added (per
   * [RFC4648] Section 3.2), but "=" appearing anywhere other than as trailing padding
   * is rejected, since the native decoder does not enforce that placement itself.
   */
  static base64Decode(str: string): Uint8Array {
    if (str.length === 0) {
      return new Uint8Array(0);
    }

    const firstPad = str.indexOf('=');
    if (firstPad !== -1 && !/^=*$/.test(str.slice(firstPad))) {
      throw new Error('"=" padding may only appear at the end of a Byte Sequence');
    }

    const remainder = str.length % 4;
    const padded = remainder === 0 ? str : str + '='.repeat(4 - remainder);

    const result = new util.Base64Helper().decodeSync(padded, util.Type.BASIC)
    if (!result) {
      throw new Error(`Invalid base64 character`);
    }
    return result
  }

  /** Encode a string to UTF-8 bytes. */
  static encodeUtf8(s: string): Uint8Array {
    const encoder = new util.TextEncoder();
    return encoder.encode(s);
  }

  /** Decode UTF-8 bytes to a string, throwing on invalid sequences. */
  static decodeUtf8(bytes: Uint8Array): string {
    const decoder = new util.TextDecoder('utf-8', { fatal: true });
    return decoder.decode(bytes);
  }
}
