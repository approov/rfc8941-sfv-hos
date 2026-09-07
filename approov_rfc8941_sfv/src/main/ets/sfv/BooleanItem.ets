import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';

/**
 * Represents a Boolean (RFC 8941 Section 3.3.6).
 * Boolean values can be conveyed in Structured Fields.
 * When serialized in a textual HTTP field,
 * a Boolean is indicated with a leading "?" character followed by a "1" for a true value
 * or "0" for false.
 * Note that in Dictionary (Section 3.2) and Parameter (Section 3.1.2) values
 * Boolean true is indicated by omitting the value
 *
 * @remarks
 * Like every other {@link Item} type in this package, parameters attach immutably via
 * {@link BooleanItem.withParams} and are stored as {@link SfvParameters}.
 * The bare-true-omission rule above is implemented in {@link SfvParameters.serialize},
 * not here — this class always serializes the explicit `?1`/`?0` form.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.3.6 | RFC 8941 §3.3.6}
 */
export class BooleanItem implements Item<boolean> {
  private static _TRUE: BooleanItem | null = null;
  private static _FALSE: BooleanItem | null = null;

  readonly value: boolean;
  readonly params: SfvParameters | null;

  private constructor(value: boolean, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link BooleanItem} instance representing the specified `boolean` value.
   *
   * @param value - a `boolean` value.
   * @returns a {@link BooleanItem} representing `value` (a cached singleton).
   */
  static valueOf(value: boolean): BooleanItem {
    if (value) {
      if (!BooleanItem._TRUE) {
        BooleanItem._TRUE = new BooleanItem(true, null);
      }
      return BooleanItem._TRUE;
    } else {
      if (!BooleanItem._FALSE) {
        BooleanItem._FALSE = new BooleanItem(false, null);
      }
      return BooleanItem._FALSE;
    }
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): BooleanItem {
    if (params.isEmpty()) {
      return this;
    }
    return new BooleanItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeBoolean(this.value) + this.getParams().serialize();
  }

  get(): boolean {
    return this.value;
  }
}
