import { describe, it } from '@ohos/hypium';
import { PARAMLIST_JSON } from './sft-data/ParamListData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(PARAMLIST_JSON) as SftTestCase[];

export default function paramListSftTest() {
  describe('sft_param_list', () => {
    it("0: basic parameterised list", 0, () => { runRoundTripCase(cases[0]); });
    it("1: single item parameterised list", 0, () => { runRoundTripCase(cases[1]); });
    it("2: missing parameter value parameterised list", 0, () => { runRoundTripCase(cases[2]); });
    it("3: missing terminal parameter value parameterised list", 0, () => { runRoundTripCase(cases[3]); });
    it("4: no whitespace parameterised list", 0, () => { runRoundTripCase(cases[4]); });
    it("5: whitespace before = parameterised list", 0, () => { runRoundTripCase(cases[5]); });
    it("6: whitespace after = parameterised list", 0, () => { runRoundTripCase(cases[6]); });
    it("7: whitespace before ; parameterised list", 0, () => { runRoundTripCase(cases[7]); });
    it("8: whitespace after ; parameterised list", 0, () => { runRoundTripCase(cases[8]); });
    it("9: extra whitespace parameterised list", 0, () => { runRoundTripCase(cases[9]); });
    it("10: two lines parameterised list", 0, () => { runRoundTripCase(cases[10]); });
    it("11: trailing comma parameterised list", 0, () => { runRoundTripCase(cases[11]); });
    it("12: empty item parameterised list", 0, () => { runRoundTripCase(cases[12]); });
    it("13: duplicate parameter with different positions", 0, () => { runRoundTripCase(cases[13]); });
    it("14: parameter ordering", 0, () => { runRoundTripCase(cases[14]); });
    it("15: trailing semicolon in parameters", 0, () => { runRoundTripCase(cases[15]); });
    it("16: trailing semicolon and space in parameters", 0, () => { runRoundTripCase(cases[16]); });
    it("17: empty parameter key", 0, () => { runRoundTripCase(cases[17]); });
    it("18: parameter prefix only", 0, () => { runRoundTripCase(cases[18]); });
    it("19: parameter prefix and space only", 0, () => { runRoundTripCase(cases[19]); });
  });
}
