/* ****************************************************** *
 *   Double InputListHandler returns Double list          *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class DoubleInputListHandler {
  List prepareList(var fileOrList, [String syncOrAsync = 'sync']) {
    List<num> _numList;
    if (fileOrList is String) {
      if (syncOrAsync == 'sync') {
        _numList = listFromFileSync(fileOrList);
      } else {
        _numList = listFromFileAsync(fileOrList);
      }
    } else if (fileOrList is List) {
      if (fileOrList.every(f(element) => element is num)) {
        _numList = new List.from(fileOrList);
      } else {
        print("The input data is not formatted correctly.");
        print("Elements must be type num or complex.");
        return(null);
      }
    }
    return _numList;
  }

  List<num> listFromFileSync(String filename) {
    List<String> _buffin;
    List<num> _buffer = [];
    File fileHandle = new File(filename);
    try {
      _buffin = fileHandle.readAsLinesSync();
    } catch(error) {
      print("There was an error opening the file:\n$error");
      return(null);
    }
    //If successfully read from file, try to parse the lines
    //as doubles to _buffer and return.
    try {
      _buffin.forEach((element) {
        if(!element.isEmpty()) _buffer.add(parseDouble(element.trim()));
        });
      return _buffer;
    } catch(error) {
      print("There was an error reading the input data:\n$error");
      return(null);
    }
  }

  List<num> listFromFileAsync(String filename) {
    //Not implemented yet...
    return(null);
  }
}