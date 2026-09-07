import { describe, it } from '@ohos/hypium';
import { TOKEN_JSON } from './sft-data/TokenData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(TOKEN_JSON) as SftTestCase[];

export default function tokenSftTest() {
  describe('sft_token', () => {
    it("0: basic token - item", 0, () => { runRoundTripCase(cases[0]); });
    it("1: token with capitals - item", 0, () => { runRoundTripCase(cases[1]); });
    it("2: token starting with capitals - item", 0, () => { runRoundTripCase(cases[2]); });
    it("3: basic token - list", 0, () => { runRoundTripCase(cases[3]); });
    it("4: token with capitals - list", 0, () => { runRoundTripCase(cases[4]); });
    it("5: token starting with capitals - list", 0, () => { runRoundTripCase(cases[5]); });
  });
}
