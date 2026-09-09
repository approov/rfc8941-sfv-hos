/**
 * Base error indicating an error while parsing a string to parameter keys
 */
export default class ParameterError extends Error {
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
      this.name = 'ParameterKeyError';
    } else {
      super(pMessageOrCause.message);
      this.name = pMessageOrCause.name;
      this.stack = pMessageOrCause.stack;
    }
  }
}


/**
 * Error raised when an string cannot be parsed as a key
 */
export class ParameterKeyParseError extends ParameterError {
  /**
   * Constructs a token fetch status error with the provided status.
   *
   * @param pStatus status returned by the Approov SDK, may be {@code null} if unavailable
   * @param pMessage information describing the error cause
   */
  constructor(pMessage: string) {
    super(pMessage);
    this.name = 'ParameterKeyParseError';
  }
}


/**
 * Error raised when a key has already existed in current Parameter scope
 */
export class ParameterReaptKeyError extends ParameterError {
  /**
   * Constructs a token fetch status error with the provided status.
   *
   * @param pStatus status returned by the Approov SDK, may be {@code null} if unavailable
   * @param pMessage information describing the error cause
   */
  constructor(pMessage: string) {
    super(pMessage);
    this.name = 'ParameterReaptKeyError';
  }
}


/**
 * Error raised when a value, which is Item already has parameters or unexpected bare value type
 */
export class ParameterValueParseError extends ParameterError {
  /**
   * Constructs a token fetch status error with the provided status.
   *
   * @param pStatus status returned by the Approov SDK, may be {@code null} if unavailable
   * @param pMessage information describing the error cause
   */
  constructor(pMessage: string) {
    super(pMessage);
    this.name = 'ParameterValueParseError';
  }
}