import { Item } from './Base';
import { SfvParameters } from './SfvParameters';
import { Serializer } from '../utils/Serializer';

/**
 * Represents a Byte Sequence (RFC 8941 Section 3.3.5).
 * Byte Sequences can be conveyed in Structured Fields.
 * The ABNF for a Byte Sequence is:
 *   sf-binary = ":" *(base64) ":"
 *   base64    = ALPHA / DIGIT / "+" / "/" / "="
 * A Byte Sequence is delimited with colons and encoded using base64 ([RFC4648], Section 4).
 *
 * @remarks
 * Base64 encoding is delegated to {@link Serializer.serializeByteSequence} on serialization,
 * and to `HttpHeaderUtils.base64Decode` on parsing — both work around
 * `@kit.ArkTS`'s `util.Base64Helper` rejecting empty/unpadded input, which the native API does
 * not handle per RFC 4648 §3.2 on its own.
 *
 * @see {@link https://www.rfc-editor.org/rfc/rfc8941#section-3.3.5 | RFC 8941 §3.3.5}
 * @see {@link https://www.rfc-editor.org/rfc/rfc4648#section-4 | RFC 4648 §4 (base64 alphabet)}
 * @see SfvParameters
 */
export class ByteSequenceItem implements Item<Uint8Array> {
   readonly value: Uint8Array;
   readonly params: SfvParameters | null;

  private constructor(value: Uint8Array, params: SfvParameters | null = null) {
    this.value = value;
    this.params = params;
  }

  /**
   * Creates a {@link ByteSequenceItem} instance representing the specified `Uint8Array` value.
   *
   * @param value - a `Uint8Array` value.
   * @returns a {@link ByteSequenceItem} representing `value`.
   */
  static valueOf(value: Uint8Array): ByteSequenceItem {
    return new ByteSequenceItem(value, null);
  }

  getParams(): SfvParameters {
    return this.params ?? SfvParameters.EMPTY;
  }

  withParams(params: SfvParameters): ByteSequenceItem {
    if (params.isEmpty()) {
      return this;
    }
    return new ByteSequenceItem(this.value, params);
  }

  serialize(): string {
    return Serializer.serializeByteSequence(this.value) + this.getParams().serialize();
  }

  /** Returns a copy of the underlying bytes. */
  get(): Uint8Array {
    return this.value.slice();
  }
}
