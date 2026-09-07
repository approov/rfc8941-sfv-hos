import { describe, it } from '@ohos/hypium';
import { DISPLAYSTRING_JSON } from './sft-data/DisplayStringData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(DISPLAYSTRING_JSON) as SftTestCase[];

export default function displayStringSftTest() {
  describe('sft_display_string', () => {
    it("0: basic display string (ascii content)", 0, () => { runRoundTripCase(cases[0]); });
    it("1: all printable ascii", 0, () => { runRoundTripCase(cases[1]); });
    it("2: non-ascii display string (uppercase escaping)", 0, () => { runRoundTripCase(cases[2]); });
    it("3: non-ascii display string (lowercase escaping)", 0, () => { runRoundTripCase(cases[3]); });
    it("4: non-ascii display string (unescaped)", 0, () => { runRoundTripCase(cases[4]); });
    it("5: tab in display string", 0, () => { runRoundTripCase(cases[5]); });
    it("6: newline in display string", 0, () => { runRoundTripCase(cases[6]); });
    it("7: single quoted display string", 0, () => { runRoundTripCase(cases[7]); });
    it("8: unquoted display string", 0, () => { runRoundTripCase(cases[8]); });
    it("9: display string missing initial quote", 0, () => { runRoundTripCase(cases[9]); });
    it("10: unbalanced display string", 0, () => { runRoundTripCase(cases[10]); });
    it("11: display string quoting", 0, () => { runRoundTripCase(cases[11]); });
    it("12: bad display string escaping", 0, () => { runRoundTripCase(cases[12]); });
    it("13: bad display string utf-8 (invalid 2-byte seq)", 0, () => { runRoundTripCase(cases[13]); });
    it("14: bad display string utf-8 (invalid sequence id)", 0, () => { runRoundTripCase(cases[14]); });
    it("15: bad display string utf-8 (invalid hex)", 0, () => { runRoundTripCase(cases[15]); });
    it("16: bad display string utf-8 (invalid 3-byte seq)", 0, () => { runRoundTripCase(cases[16]); });
    it("17: bad display string utf-8 (invalid 4-byte seq)", 0, () => { runRoundTripCase(cases[17]); });
    it("18: BOM in display string", 0, () => { runRoundTripCase(cases[18]); });
    it("19: two lines display string", 0, () => { runRoundTripCase(cases[19]); });
    it("20: truncated display string escape (zero digits)", 0, () => { runRoundTripCase(cases[20]); });
    it("21: over-encoded display string", 0, () => { runRoundTripCase(cases[21]); });
  });
}
