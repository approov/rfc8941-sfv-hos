import { expect } from '@ohos/hypium';
 import {ItemType,SfvList,Dictionary,Parser} from '@approov/rfc9651-sfv'
/**
 * Test-record shape from https://github.com/httpwg/structured-field-tests
 * (see that repo's README.md for the full format description).
 */
export interface SftTestCase {
  name: string;
  raw?: string[];
  header_type: string;
  must_fail?: boolean;
  can_fail?: boolean;
  canonical?: string[];
}
type ParseResult = ItemType | SfvList | Dictionary;

function parseByType(raw: string[], headerType: string): ParseResult {
  const parser:Parser = new Parser(raw);
  if (headerType === 'item') {
    return parser.parseItem();
  }
  if (headerType === 'list') {
    return parser.parseList();
  }
  if (headerType === 'dictionary') {
    return parser.parseDictionary();
  }
  throw new Error(`Unknown header_type: ${headerType}`);
}

/**
 * Runs one parse-side test record: parses `raw` and checks that re-serializing
 * the result reproduces `canonical` (or `raw` itself when no `canonical` is given),
 * per the round-trip equivalence the test format's README describes.
 */
export function runRoundTripCase(test: SftTestCase): void {
  const raw: string[] = test.raw ?? [];

  if (test.must_fail) {
    let threw = false;
    try {
      parseByType(raw, test.header_type);
    } catch (e) {
      threw = true;
    }
    expect(threw).assertTrue();
    return;
  }

  let result: ParseResult | null = null;
  try {
    result = parseByType(raw, test.header_type);
  } catch (e) {
    if (test.can_fail) {
      return;
    }
    throw e as Error;
  }

  const expectedSerialization = (test.canonical ?? raw).join(', ');
  expect(result.serialize()).assertEqual(expectedSerialization);
}
