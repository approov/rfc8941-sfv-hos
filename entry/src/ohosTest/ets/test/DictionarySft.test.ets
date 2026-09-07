import { describe, it } from '@ohos/hypium';
import { DICTIONARY_JSON } from './sft-data/DictionaryData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(DICTIONARY_JSON) as SftTestCase[];

export default function dictionarySftTest() {
  describe('sft_dictionary', () => {
    it("0: basic dictionary", 0, () => { runRoundTripCase(cases[0]); });
    it("1: empty dictionary", 0, () => { runRoundTripCase(cases[1]); });
    it("2: single item dictionary", 0, () => { runRoundTripCase(cases[2]); });
    it("3: list item dictionary", 0, () => { runRoundTripCase(cases[3]); });
    it("4: single list item dictionary", 0, () => { runRoundTripCase(cases[4]); });
    it("5: empty list item dictionary", 0, () => { runRoundTripCase(cases[5]); });
    it("6: no whitespace dictionary", 0, () => { runRoundTripCase(cases[6]); });
    it("7: extra whitespace dictionary", 0, () => { runRoundTripCase(cases[7]); });
    it("8: tab separated dictionary", 0, () => { runRoundTripCase(cases[8]); });
    it("9: leading whitespace dictionary", 0, () => { runRoundTripCase(cases[9]); });
    it("10: whitespace before = dictionary", 0, () => { runRoundTripCase(cases[10]); });
    it("11: whitespace after = dictionary", 0, () => { runRoundTripCase(cases[11]); });
    it("12: two lines dictionary", 0, () => { runRoundTripCase(cases[12]); });
    it("13: missing value dictionary", 0, () => { runRoundTripCase(cases[13]); });
    it("14: all missing value dictionary", 0, () => { runRoundTripCase(cases[14]); });
    it("15: start missing value dictionary", 0, () => { runRoundTripCase(cases[15]); });
    it("16: end missing value dictionary", 0, () => { runRoundTripCase(cases[16]); });
    it("17: missing value with params dictionary", 0, () => { runRoundTripCase(cases[17]); });
    it("18: explicit true value with params dictionary", 0, () => { runRoundTripCase(cases[18]); });
    it("19: trailing comma dictionary", 0, () => { runRoundTripCase(cases[19]); });
    it("20: empty item dictionary", 0, () => { runRoundTripCase(cases[20]); });
    it("21: duplicate key dictionary", 0, () => { runRoundTripCase(cases[21]); });
    it("22: dictionary key ordering", 0, () => { runRoundTripCase(cases[22]); });
    it("23: numeric key dictionary", 0, () => { runRoundTripCase(cases[23]); });
    it("24: uppercase key dictionary", 0, () => { runRoundTripCase(cases[24]); });
    it("25: bad key dictionary", 0, () => { runRoundTripCase(cases[25]); });
  });
}
