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
  // Matlab, Scilab, etc.
  void exportToFile(String filename) {
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

  //Method: export data to web using a web socket.  If data is complex,
  //send data as a real array and an imag array.
  void exportToWeb(String host, int port) {
    //connect with ws://localhost:8080/ws
    //for echo - http://www.websocket.org/echo.html
    if (host == 'local') host = '127.0.0.1';
    List _real = new List(this.data.length);
    List _imag = new List(this.data.length);
    bool _isComplex;
    if (this.data.every(f(element) => element is Complex)) {
      for (var i = 0; i < this.data.length; i++) {
        this.data[i] = this.data[i].cround2;
        _real[i] = this.data[i].real;
        _imag[i] = this.data[i].imag;
      }
      _isComplex = true;
    } else {
      _isComplex = false;
    }

    HttpServer _server = new HttpServer();
    WebSocketHandler _wsHandler = new WebSocketHandler();
    _server.addRequestHandler((req) => req.path == "/ws", _wsHandler.onRequest);

    // Open the connection.
    _wsHandler.onOpen = (WebSocketConnection wsConn) {
      print('Opening connection at $host:$port');

      // Receive message and send reply.
      wsConn.onMessage = (message) {
        var msg = JSON.parse(message);
        print("Received the following message: \n"
            "${msg["request"]}\n${msg["date"]}");
        if(_isComplex) {
          wsConn.send(JSON.stringify({"real": _real, "imag": _imag}));
        } else {
          wsConn.send(JSON.stringify({"real": this.data, "imag": null}));
        }
      };

      // Close the connection.
      wsConn.onClosed = (int status, String reason) {
        print('Connection closed: Status - $status : Reason - $reason');
      };

      // Handle a connection error.
      wsConn.onError = (err) {
        print('There was an error with the connection: $err');
      };
    };

    _server.listen(host, port);
  }
}
