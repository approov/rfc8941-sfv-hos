import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import type { StringItem } from './StringItem';

/**
 * Represents a Token (RFC 8941 Section 3.3.4).
 *
 * Tokens are short textual words that begin with an alphabetic character or "*",
 * followed by zero to many token characters,
 * which are the same as those allowed by the "token" ABNF rule defined in [HTTP] plus the ":" and "/" characters.
 *
 * @remarks
 * Character validation is delegated to {@link HttpHeaderUtils.isTokenChar}. See {@link StringItem}
 * for the quoted, full-ASCII-range counterpart of this type.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.3.4 | RFC 8941 §3.3.4}
 * @see SfvParameters
 */
export class TokenItem implements Item<string> {
  readonly value: string;
  readonly params: SfvParameters | null;

  private constructor(value: string, params: SfvParameters | null = null) {
    TokenItem.checkValue(value);
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link TokenItem} instance representing the specified `string` value.
   *
   * @param value - a `string` value.
   * @returns a {@link TokenItem} representing `value`.
   */
  static valueOf(value: string): TokenItem {
    return new TokenItem(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY
  }

  withParams(params: SfvParameters): TokenItem {
    if (params.isEmpty()) {
      return this;
    }
    return new TokenItem(this.value, params);
  }

  serialize(): string {
    return this.value + this.getParams().serialize();
  }

  get(): string {
    return this.value;
  }

  private static checkValue(value: string): void {
    HttpHeaderUtils.checkTokenValue(value);
  }
}