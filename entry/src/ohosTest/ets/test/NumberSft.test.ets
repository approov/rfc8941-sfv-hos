import { describe, it } from '@ohos/hypium';
import { NUMBER_JSON } from './sft-data/NumberData';
import { SftTestCase, runRoundTripCase } from './SftHarness';

const cases: SftTestCase[] = JSON.parse(NUMBER_JSON) as SftTestCase[];

export default function numberSftTest() {
  describe('sft_number', () => {
    it("0: basic integer", 0, () => { runRoundTripCase(cases[0]); });
    it("1: zero integer", 0, () => { runRoundTripCase(cases[1]); });
    it("2: negative zero", 0, () => { runRoundTripCase(cases[2]); });
    it("3: double negative zero", 0, () => { runRoundTripCase(cases[3]); });
    it("4: negative integer", 0, () => { runRoundTripCase(cases[4]); });
    it("5: leading 0 integer", 0, () => { runRoundTripCase(cases[5]); });
    it("6: leading 0 negative integer", 0, () => { runRoundTripCase(cases[6]); });
    it("7: leading 0 zero", 0, () => { runRoundTripCase(cases[7]); });
    it("8: comma", 0, () => { runRoundTripCase(cases[8]); });
    it("9: negative non-DIGIT first character", 0, () => { runRoundTripCase(cases[9]); });
    it("10: sign out of place", 0, () => { runRoundTripCase(cases[10]); });
    it("11: whitespace after sign", 0, () => { runRoundTripCase(cases[11]); });
    it("12: long integer", 0, () => { runRoundTripCase(cases[12]); });
    it("13: long integer followed by comma", 0, () => { runRoundTripCase(cases[13]); });
    it("14: long negative integer", 0, () => { runRoundTripCase(cases[14]); });
    it("15: too long integer", 0, () => { runRoundTripCase(cases[15]); });
    it("16: too long integer followed by comma", 0, () => { runRoundTripCase(cases[16]); });
    it("17: negative too long integer", 0, () => { runRoundTripCase(cases[17]); });
    it("18: simple decimal", 0, () => { runRoundTripCase(cases[18]); });
    it("19: negative decimal", 0, () => { runRoundTripCase(cases[19]); });
    it("20: decimal, whitespace after decimal", 0, () => { runRoundTripCase(cases[20]); });
    it("21: decimal, whitespace before decimal", 0, () => { runRoundTripCase(cases[21]); });
    it("22: negative decimal, whitespace after sign", 0, () => { runRoundTripCase(cases[22]); });
    it("23: decimal, followed by comma", 0, () => { runRoundTripCase(cases[23]); });
    it("24: tricky precision decimal", 0, () => { runRoundTripCase(cases[24]); });
    it("25: double decimal decimal", 0, () => { runRoundTripCase(cases[25]); });
    it("26: adjacent double decimal decimal", 0, () => { runRoundTripCase(cases[26]); });
    it("27: decimal with three fractional digits", 0, () => { runRoundTripCase(cases[27]); });
    it("28: negative decimal with three fractional digits", 0, () => { runRoundTripCase(cases[28]); });
    it("29: decimal with zero fractional digits", 0, () => { runRoundTripCase(cases[29]); });
    it("30: decimal with four fractional digits", 0, () => { runRoundTripCase(cases[30]); });
    it("31: negative decimal with four fractional digits", 0, () => { runRoundTripCase(cases[31]); });
    it("32: decimal with thirteen integer digits", 0, () => { runRoundTripCase(cases[32]); });
    it("33: negative decimal with thirteen integer digits", 0, () => { runRoundTripCase(cases[33]); });
    it("34: decimal with 1 significant digit and 1 insignificant digit", 0, () => { runRoundTripCase(cases[34]); });
    it("35: decimal with 1 significant digit and 2 insignificant digits", 0, () => { runRoundTripCase(cases[35]); });
    it("36: decimal with 2 significant digits and 1 insignificant digit", 0, () => { runRoundTripCase(cases[36]); });
  });
}
