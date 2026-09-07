import { describe, it } from '@ohos/hypium';
import { LARGEGENERATED_JSON } from './sft-data/LargeGeneratedData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(LARGEGENERATED_JSON) as SftTestCase[];

export default function largeGeneratedSftTest() {
  describe('sft_large_generated', () => {
    it("0: large dictionary", 0, () => { runRoundTripCase(cases[0]); });
    it("1: large dictionary key", 0, () => { runRoundTripCase(cases[1]); });
    it("2: large list", 0, () => { runRoundTripCase(cases[2]); });
    it("3: large parameterised list", 0, () => { runRoundTripCase(cases[3]); });
    it("4: large params", 0, () => { runRoundTripCase(cases[4]); });
    it("5: large param key", 0, () => { runRoundTripCase(cases[5]); });
    it("6: large string", 0, () => { runRoundTripCase(cases[6]); });
    it("7: large escaped string", 0, () => { runRoundTripCase(cases[7]); });
    it("8: large token", 0, () => { runRoundTripCase(cases[8]); });
    it("9: large byte sequence", 0, () => { runRoundTripCase(cases[9]); });
    it("10: large inner list", 0, () => { runRoundTripCase(cases[10]); });
  });
}
