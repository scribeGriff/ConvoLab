part of convolab;

/* *********************************************************** *
 *   Data format exception class extends ConvoLabException     *
 *   Library: ConvoLab (c) 2012 scribeGriff                    *
 * *********************************************************** */

class DataFormatException extends ConvoLabException {
  DataFormatException():super("Data is not formatted correctly.");
}
