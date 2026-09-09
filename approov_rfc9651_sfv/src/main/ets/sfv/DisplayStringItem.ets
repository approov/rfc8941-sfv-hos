
import { SfvParameters } from './SfvParameters';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import { Item } from './Base';
import type { StringItem } from './StringItem';

/**
 * Represents a Display String (RFC 8941 draft extension).
 * Display Strings are similar to Strings, in that they consist of zero or more characters,
 * but they allow Unicode scalar values (i.e., all Unicode code points except for surrogates), unlike Strings.
 * Display Strings are intended for use in cases where a value is displayed to end users,
 * and therefore may need to carry non-ASCII content.
 * It is NOT RECOMMENDED that they be used in situations where a String (Section 3.3.3)
 * or Token (Section 3.3.4) would be adequate because Unicode has processing considerations (e.g., normalization)
 * and security considerations (e.g., homograph attacks) that make it more difficult to handle correctly.
 *
 * @remarks
 * Prefer {@link StringItem} unless the value is genuinely user-facing and may contain
 * non-ASCII content — see the security note above.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc9651 | RFC 9651}
 * @see SfvParameters
 */
export class DisplayStringItem implements Item<string> {
   readonly value: string;
   readonly params: SfvParameters | null;

  private constructor(value: string, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link DisplayStringItem} instance representing the specified `string` value.
   *
   * @param value - a `string` value.
   * @returns a {@link DisplayStringItem} representing `value`.
   */
  static valueOf(value: string): DisplayStringItem {
    return new DisplayStringItem(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): DisplayStringItem {
    if (params.isEmpty()) {
      return this;
    }
    return new DisplayStringItem(this.value, params);
  }

  serialize(): string {
    let s = '%"';
    const octets = HttpHeaderUtils.encodeUtf8(this.value);
    for (let i = 0; i < octets.length; i++) {
      const b = octets[i];
      if (b === 0x25 || b === 0x22 || b <= 0x1f || b >= 0x7f) {
        s += '%' + b.toString(16).padStart(2, '0');
      } else {
        s += String.fromCharCode(b);
      }
    }
    return s + '"' + this.getParams().serialize();
  }

  get(): string {
    return this.value;
  }
}
