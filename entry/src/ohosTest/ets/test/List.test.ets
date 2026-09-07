
import booleanSftTest from './BooleanSft.test';
import binarySftTest from './BinarySft.test';
import dateSftTest from './DateSft.test';
import dictionarySftTest from './DictionarySft.test';
import displayStringSftTest from './DisplayStringSft.test';
import examplesSftTest from './ExamplesSft.test';
import itemSftTest from './ItemSft.test';
import listSftTest from './ListSft.test';
import listlistSftTest from './ListlistSft.test';
import paramDictSftTest from './ParamDictSft.test';
import paramListSftTest from './ParamListSft.test';
import paramListlistSftTest from './ParamListlistSft.test';
import stringSftTest from './StringSft.test';
import tokenSftTest from './TokenSft.test';
import numberSftTest from './NumberSft.test';
import keyGeneratedSftTest from './KeyGeneratedSft.test';
import largeGeneratedSftTest from './LargeGeneratedSft.test';
import numberGeneratedSftTest from './NumberGeneratedSft.test';
import stringGeneratedSftTest from './StringGeneratedSft.test';
import tokenGeneratedSftTest from './TokenGeneratedSft.test';

export default function testsuite() {
  booleanSftTest();
  binarySftTest();
  dateSftTest();
  dictionarySftTest();
  displayStringSftTest();
  examplesSftTest();
  itemSftTest();
  listSftTest();
  listlistSftTest();
  paramDictSftTest();
  paramListSftTest();
  paramListlistSftTest();
  stringSftTest();
  tokenSftTest();
  numberSftTest();
  keyGeneratedSftTest();
  largeGeneratedSftTest();
  numberGeneratedSftTest();
  stringGeneratedSftTest();
  tokenGeneratedSftTest();
}
