/* ****************************************************** *
 *   InputListHandler returns list                        *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class InputListHandler {
  List prepareList(var fileOrList, [String syncOrAsync = 'sync']) {
    List<int> _unsortedList;
    if (fileOrList is String) {
      if (syncOrAsync == 'sync') {
        _unsortedList = listFromFileSync(fileOrList);
      } else {
        _unsortedList = listFromFileAsync(fileOrList);
      }
    } else if (fileOrList is List) {
      if (fileOrList.every(f(element) => element is int)) {
        _unsortedList = new List.from(fileOrList);
      } else {
        print("The input data is not formatted correctly.");
        print("All elements must be integers.");
        return(null);
      }
    }
    return _unsortedList;
  }

  List<int> listFromFileSync(String filename) {
    List<String> _buffin;
    List<int> _buffer = [];
    File fileHandle = new File(filename);
    try {
      _buffin = fileHandle.readAsLinesSync();
    } catch(var error) {
      print("There was an error opening the file:\n$error");
      return(null);
    }
    //If successfully read from file, try to parse the lines
    //as integers to _buffer and return.
    try {
      _buffin.forEach((element) {
        if(!element.isEmpty()) _buffer.add(parseInt(element.trim()));
        });
      return _buffer;
    } catch(var error) {
      print("There was an error reading the input data:\n$error");
      return(null);
    }
  }

  List<int> listFromFileAsync(String filename) {
    List<String> _buffer;
  }
}