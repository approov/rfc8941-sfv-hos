import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import type { IntegerItem } from './IntegerItem';

/**
 * Represents a Date (RFC 9651).
 * Date values can be conveyed in Structured Fields.
 * Dates have a data model that is similar to Integers, representing a (possibly negative) delta
 * in seconds from 1970-01-01T00:00:00Z, excluding leap seconds. Accordingly, their serialization
 * in textual HTTP fields is similar to that of Integers, distinguished from them with a leading "@".
 *
 * @remarks
 * See {@link IntegerItem}, which this type otherwise mirrors — the value is stored the
 * same way (a plain `number` of seconds), only the leading `@` in serialization differs.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc9651 | RFC 9651}
 * @see SfvParameters
 */
export class DateItem implements Item<number> {
  readonly value: number;
  readonly params: SfvParameters | null;

  private constructor(value: number, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link DateItem} instance representing the specified number of seconds
   * since the epoch.
   *
   * @param value - a `number` of seconds since 1970-01-01T00:00:00Z.
   * @returns a {@link DateItem} representing `value`.
   */
  static valueOf(value: number): DateItem;
  /**
   * Creates a {@link DateItem} instance representing the specified {@link Date}, truncated
   * to whole seconds.
   *
   * @param value - a `Date` value.
   * @returns a {@link DateItem} representing `value`.
   */
  static valueOf(value: Date): DateItem;

  static valueOf(value: number | Date): DateItem {
    const seconds: number = value instanceof Date ? Math.floor(value.getTime() / 1000) : value;
    HttpHeaderUtils.checkDateValue(seconds);
    return new DateItem(seconds, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): DateItem {
    if (params.isEmpty()) {
      return this;
    }
    return new DateItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeDate(this.value) + this.getParams().serialize();
  }

  get(): number {
    return this.value;
  }
}
