import { SfvParameters } from "./SfvParameters";
import { Decimal } from "@kit.ArkTS";

/**
 * Base interface for Structured Field Data Types (RFC 9651 Section 3).
 * Every Concepts in the RFC 9651 can get serialized into HTTP Header,
 * Every Concepts in the RFC 9651 cen get the ArkTs Type values
 */
export interface Base<T> {
  readonly value:T;    // The actual Values
  serialize(): string; // serialize to HTTP standard string from RFC 9651
}

/**
 * BarItem including Items defined in RFC 9651,
 * string represents token, display string and string without parameters
 *
 */
export type BareItem = string | number | Uint8Array | boolean | Date | Decimal


/**
 * Item and innerList can have parameters,
 * Define the Base interface for
 * which are BareItems, including: Token, Decimal, Boolean, String, DisplayString, Date, Byte Sequence
 *
 */
export interface Parameterizable<T> extends Base<T> {

  readonly params: SfvParameters | null

  /**
   * Given an existing Item or InnerList, return a new instance with the specified
   * {@link Parameters}.
   *
   * @param params
  *            {@link Parameters} to set (must be non-null)
   * @return new instance with specified {@link Parameters}.
   */
  withParams(params: SfvParameters): Parameterizable<T>;
  /**
   * Given an existing {@link Item}, return
   * {@link Parameters}.
   *
   * @return {@link Parameters}.
   */
  getParams(): SfvParameters;
}

/**
 * An Item can be
 *
 * an Integer (Section 3.3.1),
 * a Decimal (Section 3.3.2),
 * a String (Section 3.3.3),
 * a Token (Section 3.3.4),
 * a Byte Sequence (Section 3.3.5),
 * a Boolean (Section 3.3.6),
 * or a Date (Section 3.3.7).
 *
 * It can have associated parameters (Section 3.1.2).
 *
 */
export interface Item<T> extends Parameterizable<T> {
  withParams(params: SfvParameters): Item<T>;
}

