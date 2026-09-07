import { Parameterizable } from './Base';
import { SfvParameters, ItemType } from './SfvParameters';
import type { ListElement } from './ListElement';
import type { SfvList } from './SfvList';
import type { Dictionary } from './Dictionary';

/**
 * An Inner List is an array of zero or more Items (Section 3.3).
 * Both the individual Items and the Inner List itself can be Parameterized (Section 3.1.2).
 * When serialized in a textual HTTP field, Inner Lists are denoted by surrounding parenthesis,
 * and their values are delimited by one or more spaces.
 *
 * @remarks
 * An `InnerList` is itself a {@link ListElement} — it can appear as a member of a
 * {@link SfvList} or as a value in a {@link Dictionary}. This is also the shape used for the
 * `@signature-params` component in RFC 9421 message signatures.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.1.1 | RFC 8941 §3.1.1}
 */
export class InnerList implements Parameterizable<ItemType[]> {
  readonly value: ItemType[];
  readonly params: SfvParameters | null;

  private constructor(value: ItemType[], params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates an {@link InnerList} instance representing the specified `ItemType[]` value.
   *
   * @param value - an `ItemType[]` value.
   * @returns an {@link InnerList} representing `value`.
   */
  static valueOf(value: ItemType[]): InnerList {
    return new InnerList(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): InnerList {
    if (params.isEmpty()) {
      return this;
    }
    return new InnerList(this.value, params);
  }

  serialize(): string {
    return `(${this.value.map((item: ItemType): string => item.serialize()).join(' ')})${this.getParams().serialize()}`;
  }

  get(): ItemType[] {
    return this.value;
  }
}
