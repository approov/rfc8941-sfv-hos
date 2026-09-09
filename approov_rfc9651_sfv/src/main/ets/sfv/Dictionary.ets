import { ListElement } from './ListElement';
import HttpHeaderUtils from '../utils/HttpHeaderUtils';
import { Serializer } from '../utils/Serializer';
import { BooleanItem } from './BooleanItem';
import type { InnerList } from './InnerList';

/**
 * Represents a Dictionary (RFC 8941 Section 3.2).
 * An ordered map of string keys to Items or Inner Lists.
 *
 * @remarks
 * Each value is a {@link ListElement} (an Item or an {@link InnerList}). Keys are validated
 * via {@link HttpHeaderUtils.checkKey}. A member whose value is the boolean `true`
 * {@link BooleanItem} serializes with its `=` sign omitted per RFC 8941 §3.1.2 — see
 * {@link Dictionary.serialize}.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.2 | RFC 8941 §3.2}
 */
export class Dictionary {
  readonly value: Map<string, ListElement>;

  private constructor(value: Map<string, ListElement>) {
    for (const key of value.keys()) {
      HttpHeaderUtils.checkKey(key);
    }
    this.value = value;
  }

  /**
   * Creates a {@link Dictionary} instance representing the specified
   * `Map<string, ListElement>` value.
   *
   * @remarks
   * The `Map` passed here must iterate predictably in insertion order — the same
   * requirement `java.util.LinkedHashMap` satisfies on the Java side — since a plain
   * ArkTS `Map` already iterates in insertion order, no special collection type is needed.
   *
   * @param value - a `Map<string, ListElement>` value.
   * @returns a {@link Dictionary} representing `value`.
   */
  static valueOf(value: Map<string, ListElement>): Dictionary {
    return new Dictionary(value);
  }

  serialize(): string {
    let s = '';
    let first = true;
    for (const entry of this.value.entries()) {
      if (!first) {
        s += ', ';
      }
      first = false;
      const name = entry[0]
      const val = entry[1]
      s += name;
      if (val instanceof BooleanItem) {
        const bool = Serializer.serializeBoolean(val.get(), true);
        if (bool !== '') {
          s += '=' + bool;
        }
        s += val.getParams().serialize();
      } else {
        s += '=' + val.serialize();
      }
    }
    return s;
  }

  get(): Map<string, ListElement> {
    return this.value;
  }
}
