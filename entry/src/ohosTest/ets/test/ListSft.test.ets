import { describe, it } from '@ohos/hypium';
import { LIST_JSON } from './sft-data/ListData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(LIST_JSON) as SftTestCase[];

export default function listSftTest() {
  describe('sft_list', () => {
    it("0: basic list", 0, () => { runRoundTripCase(cases[0]); });
    it("1: empty list", 0, () => { runRoundTripCase(cases[1]); });
    it("2: leading SP list", 0, () => { runRoundTripCase(cases[2]); });
    it("3: single item list", 0, () => { runRoundTripCase(cases[3]); });
    it("4: no whitespace list", 0, () => { runRoundTripCase(cases[4]); });
    it("5: extra whitespace list", 0, () => { runRoundTripCase(cases[5]); });
    it("6: tab separated list", 0, () => { runRoundTripCase(cases[6]); });
    it("7: two line list", 0, () => { runRoundTripCase(cases[7]); });
    it("8: trailing comma list", 0, () => { runRoundTripCase(cases[8]); });
    it("9: empty item list", 0, () => { runRoundTripCase(cases[9]); });
    it("10: empty item list (multiple field lines)", 0, () => { runRoundTripCase(cases[10]); });
  });
}
