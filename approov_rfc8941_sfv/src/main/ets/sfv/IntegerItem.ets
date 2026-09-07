import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import type { DecimalItem } from './DecimalItem';

/**
 * Represents an Integer (RFC 9651 Section 3.3.1).
 * Integers have a range of -999,999,999,999,999 to 999,999,999,999,999 inclusive (i.e., up to fifteen digits, signed),
 * for IEEE 754 compatibility [IEEE754].
 *
 * @remarks
 * Range validation is delegated to {@link HttpHeaderUtils.checkIntegerValue}. See
 * {@link DecimalItem} for the fractional counterpart of this type — values with a
 * decimal point are parsed as {@link DecimalItem}, never as `IntegerItem`.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc9651#section-3.3.1 | RFC 9651 §3.3.1}
 * @see SfvParameters
 */
export class IntegerItem implements Item<number> {
  readonly value: number;
  readonly params: SfvParameters | null;

  private constructor(value: number, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates an {@link IntegerItem} instance representing the specified `number` value.
   *
   * @param value - a `number` value; must be a safe integer within RFC 9651's fifteen-digit range.
   * @returns an {@link IntegerItem} representing `value`.
   * @throws if `value` is out of range — see {@link HttpHeaderUtils.checkIntegerValue}.
   */
  static valueOf(value: number): IntegerItem {
    HttpHeaderUtils.checkIntegerValue(value);
    return new IntegerItem(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): IntegerItem {
    if (params.isEmpty()) {
      return this;
    }
    return new IntegerItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeInteger(this.value) + this.getParams().serialize();
  }

  get(): number {
    return this.value;
  }
}
