import { describe, it } from '@ohos/hypium';
import { LISTLIST_JSON } from './sft-data/ListlistData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(LISTLIST_JSON) as SftTestCase[];

export default function listlistSftTest() {
  describe('sft_listlist', () => {
    it("0: basic list of lists", 0, () => { runRoundTripCase(cases[0]); });
    it("1: single item list of lists", 0, () => { runRoundTripCase(cases[1]); });
    it("2: empty item list of lists", 0, () => { runRoundTripCase(cases[2]); });
    it("3: empty middle item list of lists", 0, () => { runRoundTripCase(cases[3]); });
    it("4: extra whitespace list of lists", 0, () => { runRoundTripCase(cases[4]); });
    it("5: wrong whitespace list of lists", 0, () => { runRoundTripCase(cases[5]); });
    it("6: no trailing parenthesis list of lists", 0, () => { runRoundTripCase(cases[6]); });
    it("7: no trailing parenthesis middle list of lists", 0, () => { runRoundTripCase(cases[7]); });
    it("8: no spaces in inner-list", 0, () => { runRoundTripCase(cases[8]); });
    it("9: no closing parenthesis", 0, () => { runRoundTripCase(cases[9]); });
    it("10: nested inner lists", 0, () => { runRoundTripCase(cases[10]); });
    it("11: dictionary in inner list", 0, () => { runRoundTripCase(cases[11]); });
  });
}
