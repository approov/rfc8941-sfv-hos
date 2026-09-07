import { describe, it } from '@ohos/hypium';
import { EXAMPLES_JSON } from './sft-data/ExamplesData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(EXAMPLES_JSON) as SftTestCase[];

export default function examplesSftTest() {
  describe('sft_examples', () => {
    it("0: Foo-Example", 0, () => { runRoundTripCase(cases[0]); });
    it("1: Example-StrListHeader", 0, () => { runRoundTripCase(cases[1]); });
    it("2: Example-Hdr (list on one line)", 0, () => { runRoundTripCase(cases[2]); });
    it("3: Example-Hdr (list on two lines)", 0, () => { runRoundTripCase(cases[3]); });
    it("4: Example-StrListListHeader", 0, () => { runRoundTripCase(cases[4]); });
    it("5: Example-ListListParam", 0, () => { runRoundTripCase(cases[5]); });
    it("6: Example-ParamListHeader", 0, () => { runRoundTripCase(cases[6]); });
    it("7: Example-IntHeader", 0, () => { runRoundTripCase(cases[7]); });
    it("8: Example-DictHeader", 0, () => { runRoundTripCase(cases[8]); });
    it("9: Example-DictHeader (boolean values)", 0, () => { runRoundTripCase(cases[9]); });
    it("10: Example-DictListHeader", 0, () => { runRoundTripCase(cases[10]); });
    it("11: Example-MixDict", 0, () => { runRoundTripCase(cases[11]); });
    it("12: Example-Hdr (dictionary on one line)", 0, () => { runRoundTripCase(cases[12]); });
    it("13: Example-Hdr (dictionary on two lines)", 0, () => { runRoundTripCase(cases[13]); });
    it("14: Example-IntItemHeader", 0, () => { runRoundTripCase(cases[14]); });
    it("15: Example-IntItemHeader (params)", 0, () => { runRoundTripCase(cases[15]); });
    it("16: Example-IntegerHeader", 0, () => { runRoundTripCase(cases[16]); });
    it("17: Example-FloatHeader", 0, () => { runRoundTripCase(cases[17]); });
    it("18: Example-StringHeader", 0, () => { runRoundTripCase(cases[18]); });
    it("19: Example-BinaryHdr", 0, () => { runRoundTripCase(cases[19]); });
    it("20: Example-BoolHdr", 0, () => { runRoundTripCase(cases[20]); });
  });
}
