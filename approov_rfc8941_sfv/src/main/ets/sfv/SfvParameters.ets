import HttpHeaderUtils from '../utils/HttpHeaderUtils';

import { BooleanItem } from './BooleanItem';
import { IntegerItem } from './IntegerItem';
import { DecimalItem } from './DecimalItem';
import { DateItem } from './DateItem';
import { StringItem } from './StringItem';
import { TokenItem } from './TokenItem';
import { ByteSequenceItem } from './ByteSequenceItem';
import { DisplayStringItem } from './DisplayStringItem';
import { BareItem } from './Base';
import { Decimal } from '@kit.ArkTS';
import ItemParseError from '../error/ItemParseError';
import { ParameterValueParseError, ParameterReaptKeyError } from '../error/ParameterError';
import { Serializer } from '../utils/Serializer';

/** Union of valid Item types storable as parameter values. */
export type ItemType = BooleanItem | IntegerItem | DecimalItem | DateItem
  | StringItem | TokenItem | ByteSequenceItem | DisplayStringItem;


/**
 * Input value that can be converted to a bare SFV Item.
 *
 * Concrete SFV Item instances are used as-is.
 * Supported primitive values are converted by SfvParameters.
 * valueOf:
 *
 * string to StringItem or DisplayStringItem
 * number to IntegerItem or DecimalItem,
 * Decimal to DecimalItem
 * date to DateItem
 * boolean to BooleanItem,
 * and Uint8Array to ByteSequenceItem.
 */
export type SfvItemInput = ItemType | BareItem


/**
 * Parameters are an ordered map of key-value pairs that are associated with
 * an Item or Inner List. The keys are unique within the scope of the
 * Parameters they occur within, and the values are bare items (i.e., they
 * themselves cannot be parameterized.
 *
 *
 * Implementations MUST provide access to Parameters both by index and by key.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.1.2 | RFC 8941 §3.1.2}
 */
export class SfvParameters {
  private readonly delegate : Map<string, ItemType>;
  static readonly  EMPTY : SfvParameters = new SfvParameters(new Map<string, ItemType>())

  private constructor(delegate: Map<string, ItemType>) {
    this.delegate = delegate;
  }

  /**
   * Creates a {@link SfvParameters} instance from a raw value map.
   *
   * @remarks
   * The `Map` passed here needs to iterate predictably based on insertion order (a plain
   * ArkTS `Map` already does). Values may be {@link ItemType} instances directly, or any
   * {@link SfvItemInput} primitive (`number`/`string`/`boolean`/`Decimal`/`Uint8Array`),
   * which are converted to the corresponding bare Item — see `toParamItem`.
   *
   * @param value - a `Map<string, SfvItemInput>` value.
   * @returns a {@link SfvParameters} representing `value`.
   */
  static valueOf(value: Map<string, SfvItemInput>): SfvParameters {
    const result: Map<string, ItemType> = new Map<string, ItemType>();
    for (const entry of value.entries()) {
      const k = entry[0]
      const v = entry[1]
      HttpHeaderUtils.checkKey(k);
      const item = SfvParameters.toParamItem(k, v);
      if (!item.getParams().isEmpty()) {
        throw new ParameterValueParseError(`Parameter value for '${k}' must be bare item (no parameters)`);
      }
      result.set(k, item);
    }
    return new SfvParameters(result);
  }

  /**
   * Returns a new SfvParameters with `key` set to `value`.
   * Throws if `key` already exists in this SfvParameters.
   */
  add(key: string, value: SfvItemInput): SfvParameters {
    HttpHeaderUtils.checkKey(key);
    if (this.delegate.has(key)) {
      throw new ParameterReaptKeyError(`Parameter key '${key}' already exists`);
    }
    const item = SfvParameters.toParamItem(key, value);
    if (!item.getParams().isEmpty()) {
      throw new ParameterValueParseError(`Parameter value for '${key}' must be bare item (no parameters)`);
    }
    const result: Map<string, ItemType> = new Map<string, ItemType>(this.delegate);
    result.set(key, item);
    return new SfvParameters(result);
  }

  serialize(): string {
    let s = '';
    for (const entry of this.delegate.entries()) {
      const k = entry[0]
      const v = entry[1]
      s += ';' + k;
      if (v instanceof BooleanItem) {
        const bool = Serializer.serializeBoolean(v.get(), true);
        if (bool !== '') {
          s += '=' + bool;
        }
      } else {
        s += '=' + v.serialize();
      }
    }
    return s;
  }

  isEmpty(): boolean {
    return this.delegate.size === 0;
  }

  containsKey(key: string): boolean {
    return this.delegate.has(key);
  }

  get(key: string): ItemType | undefined {
    return this.delegate.get(key);
  }

  entrySet(): IterableIterator<[string, ItemType]> {
    return this.delegate.entries();
  }

  keySet(): IterableIterator<string> {
    return this.delegate.keys();
  }

  values(): IterableIterator<ItemType> {
    return this.delegate.values();
  }

  size(): number {
    return this.delegate.size;
  }

  equals(other: SfvParameters): boolean {
    if (this.delegate.size !== other.delegate.size) {
      return false;
    }
    for (const entry of this.delegate.entries()) {
      const k = entry[0]
      const v = entry[1]

      if (!other.delegate.has(k)) {
        return false;
      }
      const ov = other.delegate.get(k)!;
      if (!SfvParameters.paramItemEquals(v, ov)) {
        return false;
      }
    }
    return true;
  }

  /**
   *
   * Converts a raw parameter value (a concrete Item instance, or a plain string/number/
   * boolean/Uint8Array/Date/Decimal) into a bare Item suitable for storage in SfvParameters.
   *
   **/
  static toParamItem(key: string, o: SfvItemInput): ItemType {
    if (o instanceof BooleanItem || o instanceof IntegerItem || o instanceof DecimalItem
      || o instanceof DateItem || o instanceof StringItem || o instanceof TokenItem
      || o instanceof ByteSequenceItem || o instanceof DisplayStringItem) {
      return o;
    }
    if (typeof o === 'number') {
      return IntegerItem.valueOf(o);
    }
    if (typeof o === 'string') {
      return StringItem.valueOf(o);
    }
    if (typeof o === 'boolean') {
      return BooleanItem.valueOf(o);
    }
    if (o instanceof Uint8Array) {
      return ByteSequenceItem.valueOf(o);
    }
    if (o instanceof Decimal) {
      return DecimalItem.valueOf(o);
    }
    if (o instanceof Date) {
      return DateItem.valueOf(o);
    }
    throw new ItemParseError(`Can't map value for parameter '${key}': ${typeof o}`);
  }

  private static paramItemEquals(a: ItemType, b: ItemType): boolean {
    const av = a.get();
    const bv = b.get();
    if (av instanceof Uint8Array && bv instanceof Uint8Array) {
      if (av.length !== bv.length) {
        return false;
      }
      for (let i = 0; i < av.length; i++) {
        if (av[i] !== bv[i]) {
          return false;
        }
      }
      return a.getParams().equals(b.getParams());
    }
    return av === bv && a.getParams().equals(b.getParams());
  }
}


