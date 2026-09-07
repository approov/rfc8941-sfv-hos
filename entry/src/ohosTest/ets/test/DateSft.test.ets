import { describe, it } from '@ohos/hypium';
import { DATE_JSON } from './sft-data/DateData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(DATE_JSON) as SftTestCase[];

export default function dateSftTest() {
  describe('sft_date', () => {
    it("0: date - 1970-01-01 00:00:00", 0, () => { runRoundTripCase(cases[0]); });
    it("1: date - 2022-08-04 01:57:13", 0, () => { runRoundTripCase(cases[1]); });
    it("2: date - 1917-05-30 22:02:47", 0, () => { runRoundTripCase(cases[2]); });
    it("3: date - 2^31", 0, () => { runRoundTripCase(cases[3]); });
    it("4: date - 2^32", 0, () => { runRoundTripCase(cases[4]); });
    it("5: interoperability max date - 9999-12-31 00:00:00", 0, () => { runRoundTripCase(cases[5]); });
    it("6: interoperability min date - 0001-01-01 00:00:00", 0, () => { runRoundTripCase(cases[6]); });
    it("7: date - decimal", 0, () => { runRoundTripCase(cases[7]); });
    it("8: syntactic max date - 999,999,999,999,999", 0, () => { runRoundTripCase(cases[8]); });
    it("9: syntactic min date - -999,999,999,999,999", 0, () => { runRoundTripCase(cases[9]); });
    it("10: too large syntactic date - 1,000,000,000,000,000", 0, () => { runRoundTripCase(cases[10]); });
    it("11: too small syntactic date - -1,000,000,000,000,000", 0, () => { runRoundTripCase(cases[11]); });
    it("12: date with negative zero", 0, () => { runRoundTripCase(cases[12]); });
    it("13: date - empty", 0, () => { runRoundTripCase(cases[13]); });
    it("14: date - sign only", 0, () => { runRoundTripCase(cases[14]); });
    it("15: date - space", 0, () => { runRoundTripCase(cases[15]); });
    it("16: date - non-digit", 0, () => { runRoundTripCase(cases[16]); });
  });
}
