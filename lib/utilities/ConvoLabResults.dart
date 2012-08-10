/* ****************************************************** *
 *   Standard results class                               *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class ConvoLabResults {
  final List data;
  final int value;

  ConvoLabResults(this.data, this.value);

  // Method: export writes data list to a file.  If the data is complex,
  // the external file is tab delimited.  Data can then be read into
  // Matlab, Scilab, etc.  This is temporary until we develop the html5
  // data visualizer (ie, ConvoWeb).
  void export(String filename) {
    File fileHandle = new File(filename);
    RandomAccessFile dataFile = fileHandle.openSync(FileMode.WRITE);
    if (this.data.every(f(element) => element is Complex)) {
      for (var i = 0; i < this.data.length; i++) {
        this.data[i] = this.data[i].cround2;
        dataFile.writeStringSync("${this.data[i].real}\t${this.data[i].imag}\n");
      }
    } else {
      for (var i = 0; i < this.data.length; i++) {
        dataFile.writeStringSync("${this.data[i]}\n");
      }
    }
    dataFile.closeSync();
  }
}
