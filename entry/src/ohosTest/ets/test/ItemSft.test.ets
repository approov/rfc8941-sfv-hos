import { describe, it } from '@ohos/hypium';
import { ITEM_JSON } from './sft-data/ItemData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(ITEM_JSON) as SftTestCase[];

export default function itemSftTest() {
  describe('sft_item', () => {
    it("0: empty item", 0, () => { runRoundTripCase(cases[0]); });
    it("1: leading space", 0, () => { runRoundTripCase(cases[1]); });
    it("2: trailing space", 0, () => { runRoundTripCase(cases[2]); });
    it("3: leading and trailing space", 0, () => { runRoundTripCase(cases[3]); });
    it("4: leading and trailing whitespace", 0, () => { runRoundTripCase(cases[4]); });
  });
}
