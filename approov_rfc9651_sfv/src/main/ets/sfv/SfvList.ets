import type { Base } from './Base';
import { ListElement } from './ListElement';
import type { InnerList } from './InnerList';

/**
 * Represents a List (RFC 8941 Section 3.1).
 * Lists are arrays of zero or more members, each of which can be an Item (Section 3.3) or an Inner List (Section 3.1.1),
 * both of which can be Parameterized (Section 3.1.2).
 * An empty List is denoted by not serializing the field at all.
 * This implies that fields defined as Lists have a default empty value.
 * When serialized as a textual HTTP field, each member is separated by a comma and optional whitespace.
 *
 * @remarks
 * Each member is a {@link ListElement} — either an Item or an {@link InnerList}. This is the
 * type produced by `parseList()` for fields such as `Accept-Encoding`.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.1 | RFC 8941 §3.1}
 */
export class SfvList implements Base<ListElement[]> {
  readonly value: ListElement[];

  private constructor(value: ListElement[]) {
    this.value = value;
  }

  /**
   * Creates a {@link SfvList} instance representing the specified `ListElement[]` value.
   *
   * @param value - a `ListElement[]` value.
   * @returns a {@link SfvList} representing `value`.
   */
  static valueOf(value: ListElement[]): SfvList {
    return new SfvList(value);
  }

  serialize(): string {
    return this.value.map((item: ListElement): string => item.serialize()).join(', ');
  }

  get(): ListElement[] {
    return this.value;
  }
}
