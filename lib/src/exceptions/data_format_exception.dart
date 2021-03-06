// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Exception for improperly formatted data.
 */

class DataFormatException extends ConvoLabException {
  DataFormatException():super("Data is not formatted correctly.");
}
