import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import { Decimal } from '@kit.ArkTS';
import type { IntegerItem } from './IntegerItem';

/**
 * Represents a Decimal (RFC 9651 Section 3.3.2).
 * Decimals are numbers with an integer and a fractional component. The integer component
 * has at most 12 digits; the fractional component has at most three digits.
 * While it is possible to represent Decimals with leading zeros, trailing zeros, and signed
 * zero, these distinctions are not preserved by serialization.
 * The serialization algorithm (Section 4.1.5) rounds input with more than three digits of
 * precision in the fractional component, using round-half-to-even for ties.
 *
 * @remarks
 * Rounding and range checks are delegated to {@link HttpHeaderUtils.checkDecimalValue}, which
 * accepts a plain `number` or an `@kit.ArkTS` {@link Decimal} for exact round-half-to-even
 * behavior. See {@link IntegerItem} for the whole-number counterpart of this type.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc9651#section-3.3.2 | RFC 9651 §3.3.2}
 * @see {@link https://www.rfc-editor.org/rfc/rfc9651#section-4.1.5 | RFC 9651 §4.1.5 (rounding algorithm)}
 * @see SfvParameters
 */
export class DecimalItem implements Item<number> {
  readonly value: number;
  readonly params: SfvParameters | null;

  private constructor(value: number, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link DecimalItem} instance representing the specified `number` value,
   * rounded to 3 fractional digits using round-half-to-even.
   *
   * @param value - a `number` value.
   * @returns a {@link DecimalItem} representing `value`.
   */
  static valueOf(value: number): DecimalItem;
  /**
   * Creates a {@link DecimalItem} instance representing the specified {@link Decimal}
   * (`@kit.ArkTS`) value, with potential rounding.
   *
   * @param value - a `Decimal` value.
   * @returns a {@link DecimalItem} representing `value`.
   */
  static valueOf(value: Decimal): DecimalItem;
  static valueOf(value: number | Decimal): DecimalItem {
    // checkDecimalValue validates and rounds in one pass, returning the fixed-point string;
    // reuse it directly instead of re-deriving a Decimal from the original `value`.
    const rounded: string = HttpHeaderUtils.checkDecimalValue(value);
    return new DecimalItem(Number(rounded), null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): DecimalItem {
    if (params.isEmpty()) {
      return this;
    }
    return new DecimalItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeDecimal(this.value) + this.getParams().serialize();
  }

  get(): number {
    return this.value;
  }
}
