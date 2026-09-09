import { InnerList } from './InnerList';
import { ItemType } from './SfvParameters';

/**
 * Elements that can appear in Lists and Dictionaries (RFC 8941 Section 3.1).
 */
export type ListElement = ItemType | InnerList;
