/**
 * Error thrown by the SFV Parser when input is malformed.
 */
export class ParseError extends Error {
  readonly position: number;
  readonly data: string;

  constructor(message: string, input: string, position: number = 0, cause?: Error) {
    super(message);
    this.name = 'ParseError';
    this.data = input;
    this.position = position;
    if (cause) {
      this.stack = (this.stack ?? '') + '\nCaused by: ' + (cause.stack ?? cause.message);
    }
  }

  getDiagnostics(): string {
    let sb = `>>${this.data}<<\n`;
    sb += '  ';
    for (let i = 0; i < this.position; i++) {
      sb += '-';
    }
    sb += '^ ';
    if (this.position < this.data.length) {
      const c = this.data.charCodeAt(this.position);
      sb += `(0x${c.toString(16).padStart(2, '0')}) `;
    }
    sb += this.message + '\n';
    return sb;
  }
}
