import { describe, it } from '@ohos/hypium';
import { PARAMLISTLIST_JSON } from './sft-data/ParamListlistData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(PARAMLISTLIST_JSON) as SftTestCase[];

export default function paramListlistSftTest() {
  describe('sft_param_listlist', () => {
    it("0: parameterised inner list", 0, () => { runRoundTripCase(cases[0]); });
    it("1: parameterised inner list item", 0, () => { runRoundTripCase(cases[1]); });
    it("2: parameterised inner list with parameterised item", 0, () => { runRoundTripCase(cases[2]); });
  });
}
