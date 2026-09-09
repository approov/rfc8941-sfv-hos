
/**
 * Base error indicating an error while parsing Arkts type to RFC Concepts
 */
export default class ItemParseError extends Error {
  /**
   * Constructs an error due to an ItemParseError error.
   *
   * @param pMessage information describing the error cause
   */
  constructor(pMessage: string);

  /**
   * Constructs an error with an underlying cause, using the cause message when available.
   *
   * @param pCause underlying cause of the error
   */
  constructor(pCause: Error);

  constructor(pMessageOrCause: string | Error) {
    if (typeof pMessageOrCause === 'string') {
      super(pMessageOrCause);
      this.name = 'ItemParseError';
    } else {
      super(pMessageOrCause.message);
      this.name = pMessageOrCause.name;
      this.stack = pMessageOrCause.stack;
    }
  }
}