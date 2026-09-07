import { describe, it } from '@ohos/hypium';
import { BOOLEAN_JSON } from './sft-data/BooleanData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(BOOLEAN_JSON) as SftTestCase[];

export default function booleanSftTest() {
  describe('sft_boolean', () => {
    it("0: basic true boolean", 0, () => { runRoundTripCase(cases[0]); });
    it("1: basic false boolean", 0, () => { runRoundTripCase(cases[1]); });
    it("2: unknown boolean", 0, () => { runRoundTripCase(cases[2]); });
    it("3: whitespace boolean", 0, () => { runRoundTripCase(cases[3]); });
    it("4: negative zero boolean", 0, () => { runRoundTripCase(cases[4]); });
    it("5: T boolean", 0, () => { runRoundTripCase(cases[5]); });
    it("6: F boolean", 0, () => { runRoundTripCase(cases[6]); });
    it("7: t boolean", 0, () => { runRoundTripCase(cases[7]); });
    it("8: f boolean", 0, () => { runRoundTripCase(cases[8]); });
    it("9: spelled-out True boolean", 0, () => { runRoundTripCase(cases[9]); });
    it("10: spelled-out False boolean", 0, () => { runRoundTripCase(cases[10]); });
    it("11: boolean prefix only", 0, () => { runRoundTripCase(cases[11]); });
  });
}
