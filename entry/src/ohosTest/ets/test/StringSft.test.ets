import { describe, it } from '@ohos/hypium';
import { STRING_JSON } from './sft-data/StringData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(STRING_JSON) as SftTestCase[];

export default function stringSftTest() {
  describe('sft_string', () => {
    it("0: basic string", 0, () => { runRoundTripCase(cases[0]); });
    it("1: empty string", 0, () => { runRoundTripCase(cases[1]); });
    it("2: long string", 0, () => { runRoundTripCase(cases[2]); });
    it("3: whitespace string", 0, () => { runRoundTripCase(cases[3]); });
    it("4: non-ascii string", 0, () => { runRoundTripCase(cases[4]); });
    it("5: tab in string", 0, () => { runRoundTripCase(cases[5]); });
    it("6: newline in string", 0, () => { runRoundTripCase(cases[6]); });
    it("7: single quoted string", 0, () => { runRoundTripCase(cases[7]); });
    it("8: unbalanced string", 0, () => { runRoundTripCase(cases[8]); });
    it("9: string quoting", 0, () => { runRoundTripCase(cases[9]); });
    it("10: bad string quoting", 0, () => { runRoundTripCase(cases[10]); });
    it("11: ending string quote", 0, () => { runRoundTripCase(cases[11]); });
    it("12: abruptly ending string quote", 0, () => { runRoundTripCase(cases[12]); });
    it("13: two lines string", 0, () => { runRoundTripCase(cases[13]); });
  });
}
