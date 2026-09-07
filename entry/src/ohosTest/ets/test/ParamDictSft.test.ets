import { describe, it } from '@ohos/hypium';
import { PARAMDICT_JSON } from './sft-data/ParamDictData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(PARAMDICT_JSON) as SftTestCase[];

export default function paramDictSftTest() {
  describe('sft_param_dict', () => {
    it("0: basic parameterised dict", 0, () => { runRoundTripCase(cases[0]); });
    it("1: single item parameterised dict", 0, () => { runRoundTripCase(cases[1]); });
    it("2: list item parameterised dictionary", 0, () => { runRoundTripCase(cases[2]); });
    it("3: missing parameter value parameterised dict", 0, () => { runRoundTripCase(cases[3]); });
    it("4: terminal missing parameter value parameterised dict", 0, () => { runRoundTripCase(cases[4]); });
    it("5: no whitespace parameterised dict", 0, () => { runRoundTripCase(cases[5]); });
    it("6: whitespace before = parameterised dict", 0, () => { runRoundTripCase(cases[6]); });
    it("7: whitespace after = parameterised dict", 0, () => { runRoundTripCase(cases[7]); });
    it("8: whitespace before ; parameterised dict", 0, () => { runRoundTripCase(cases[8]); });
    it("9: whitespace after ; parameterised dict", 0, () => { runRoundTripCase(cases[9]); });
    it("10: extra whitespace parameterised dict", 0, () => { runRoundTripCase(cases[10]); });
    it("11: two lines parameterised list", 0, () => { runRoundTripCase(cases[11]); });
    it("12: trailing comma parameterised list", 0, () => { runRoundTripCase(cases[12]); });
    it("13: empty item parameterised list", 0, () => { runRoundTripCase(cases[13]); });
  });
}
