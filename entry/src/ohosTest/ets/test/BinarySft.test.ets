import { describe, it } from '@ohos/hypium';
import { BINARY_JSON } from './sft-data/BinaryData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(BINARY_JSON) as SftTestCase[];

export default function binarySftTest() {
  describe('sft_binary', () => {
    it("0: basic binary", 0, () => { runRoundTripCase(cases[0]); });
    it("1: empty binary", 0, () => { runRoundTripCase(cases[1]); });
    it("2: padding at beginning", 0, () => { runRoundTripCase(cases[2]); });
    it("3: padding in middle", 0, () => { runRoundTripCase(cases[3]); });
    it("4: bad padding", 0, () => { runRoundTripCase(cases[4]); });
    it("5: bad padding dot", 0, () => { runRoundTripCase(cases[5]); });
    it("6: bad end delimiter", 0, () => { runRoundTripCase(cases[6]); });
    it("7: extra whitespace", 0, () => { runRoundTripCase(cases[7]); });
    it("8: all whitespace", 0, () => { runRoundTripCase(cases[8]); });
    it("9: extra chars", 0, () => { runRoundTripCase(cases[9]); });
    it("10: suffix chars", 0, () => { runRoundTripCase(cases[10]); });
    it("11: non-zero pad bits", 0, () => { runRoundTripCase(cases[11]); });
    it("12: non-ASCII binary", 0, () => { runRoundTripCase(cases[12]); });
    it("13: base64url binary", 0, () => { runRoundTripCase(cases[13]); });
    it("14: binary prefix only", 0, () => { runRoundTripCase(cases[14]); });
  });
}
