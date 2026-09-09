import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import type { TokenItem } from './TokenItem';
import type { DisplayStringItem } from './DisplayStringItem';


/**
 * Represents a String (RFC 8941 Section 3.3.3).
 * Strings are zero or more printable ASCII [RFC0020] characters (i.e., the range %x20 to %x7E).
 * Note that this excludes tabs, newlines, carriage returns, etc.
 *
 * @remarks
 * See {@link TokenItem} for the unquoted, charset-restricted sibling of this type (e.g. HTTP
 * method names, algorithm identifiers), and {@link DisplayStringItem} for the Unicode-capable
 * variant intended for values shown to end users.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.3.3 | RFC 8941 §3.3.3}
 * @see SfvParameters
 */
export class StringItem implements Item<string> {
  readonly value: string;
  readonly params: SfvParameters | null;

  private constructor(value: string, params: SfvParameters | null = null) {
    StringItem.checkValue(value);
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link StringItem} instance representing the specified `string` value.
   *
   * @param value - a `string` value.
   * @returns a {@link StringItem} representing `value`.
   */
  static valueOf(value: string): StringItem {
    return new StringItem(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): StringItem {
    if (params.isEmpty()) {
      return this;
    }
    return new StringItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeString(this.value) + this.getParams().serialize();
  }

  get(): string {
    return this.value;
  }

  private static checkValue(value: string): void {
    HttpHeaderUtils.checkStringValue(value);
  }
}
