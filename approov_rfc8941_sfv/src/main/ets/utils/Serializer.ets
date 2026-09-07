import HttpHeaderUtils from './HttpHeaderUtils';
import { Decimal } from '@kit.ArkTS';
import ItemParseError from '../error/ItemParseError';
import { BareItem } from '../sfv/Base';
import { ParameterValueParseError } from '../error/ParameterError';

const BOOLEAN_TRUE: string = '?1';
const BOOLEAN_FALSE: string = '?0';

export class Serializer {

  static serializeString(value: string): string {
    HttpHeaderUtils.checkStringValue(value);
    return `"${value.replace(/("|\\)/g, (match: string): string => '\\' + match)}"`;
  }

  /**
   * Serializes a Boolean bare value (RFC 8941 Section 4.1.9).
   * When shouldOmit is true, a `true` value is serialized as an empty string, since both
   * a Parameter (Section 4.1.1.2) and a Dictionary member (Section 4.1.2) omit "=?1" for a
   * bare-key entry whose value is Boolean true.
   */
  static serializeBoolean(value: boolean, shouldOmit: boolean = false): string {
    if (value && shouldOmit) {
      return '';
    }
    return value ? BOOLEAN_TRUE : BOOLEAN_FALSE;
  }

  /**
   * Serializes a Date bare value (RFC 9651 Section 4.1.10).
   * Dates are serialized like Integers, distinguished by a leading "@".
   */
  static serializeDate(value: number | Date): string {
    const seconds: number = value instanceof Date ? Math.floor(value.getTime() / 1000) : value;
    HttpHeaderUtils.checkDateValue(seconds);
    return '@' + String(seconds);
  }

  /**
   * Serializes a Byte Sequence bare value (RFC 9651 Section 4.1.8).
   * Delimited with colons and base64-encoded per [RFC4648] Section 4, padded with "="
   * per Section 3.2 (required) with pad bits set to zero per Section 3.5.
   */
  static serializeByteSequence(value: Uint8Array): string {
    return ':' + HttpHeaderUtils.base64Encode(value) + ':';
  }

  /**
   * Serializes a Decimal bare value (RFC 9651 Section 4.1.5).
   * Rounded to 3 fractional digits using round-half-to-even, then trailing zeros are
   * stripped from the fractional component -- except when it rounds to exactly zero,
   * in which case a single "0" is kept so the value always has at least one fractional digit.
   */
  static serializeDecimal(value: number | Decimal): string {
    let out: string = HttpHeaderUtils.checkDecimalValue(value).replace(/0+$/, '');
    if (out.endsWith('.')) {
      out += '0';
    }
    return out;
  }

  /**
   * Serializes an Integer bare value (RFC 9651 Section 4.1.4).
   */
  static serializeInteger(value: number): string {
    HttpHeaderUtils.checkIntegerValue(value);
    return String(value);
  }

  /**
   * Serializes a Parameters map (RFC 9651 Section 4.1.1.2): each entry becomes ";key",
   * followed by "=value" unless the value is Boolean true, which is represented by the
   * bare key alone. A plain `number` is treated as an Integer when it is a whole number,
   * and a Decimal otherwise.
   */
  static serializeParameters(value: Map<string, BareItem>): string {
    let s = '';
    for (const entry of value.entries()) {
      const k = entry[0];
      const v = entry[1];
      HttpHeaderUtils.checkKey(k);
      s += ';' + k;
      switch (typeof v) {
        case 'boolean':
          s += Serializer.serializeBoolean(v, true);
          break;
        case 'string':
          s += '=' + Serializer.serializeString(v);
          break;
        case 'number':
          s += '=' + (Number.isInteger(v) ? Serializer.serializeInteger(v) : Serializer.serializeDecimal(v));
          break;
        default:
          if (v instanceof Decimal) {
            s += '=' + Serializer.serializeDecimal(v);
          } else if (v instanceof Date) {
            s += '=' + Serializer.serializeDate(v);
          } else if (v instanceof Uint8Array) {
            s += '=' + Serializer.serializeByteSequence(v);
          } else {
            throw new ParameterValueParseError(`Can't serialize bare paraeter item of type: ${typeof v}`);
          }
      }
    }
    return s;
  }
}
