/* ****************************************************** *
 *   FSPSResults extends standard results class           *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class FSPSResults extends ConvoLabResults {
  final Map psums, jsonData;

  //Return a list of the input waveform and also a Map of the
  //partial sums indexed to the value for k.
  FSPSResults(List data, this.psums, this.jsonData) : super(data);

  //Override standard results class methods exportToFile() and exportToWeb().
  void exportToFile(String filename) {
    List<String> tokens = filename.split(const RegExp(r'\.(?=[^.]+$)'));
    if (tokens.length == 1) tokens.add('txt');
    psums.forEach((k, v) {
      File fileHandle = new File('${tokens[0]}_k$k.${tokens[1]}');
      RandomAccessFile dataFile = fileHandle.openSync(FileMode.WRITE);
      for (var i = 0; i < psums[k].length; i++) {
        dataFile.writeStringSync('${psums[k][i].real}\t'
            '${psums[k][i].imag}\n');
      }
      dataFile.closeSync();
    });
    File fileHandle = new File('${tokens[0]}_data.${tokens[1]}');
    RandomAccessFile dataFile = fileHandle.openSync(FileMode.WRITE);
    for (var i = 0; i < data.length; i++) {
      dataFile.writeStringSync('${data[i]}\n');
    }
    dataFile.closeSync();
  }

  //Method: export data to web using a web socket.
  void exportToWeb(String host, int port) {
    //connect with ws://localhost:8080/ws
    //for echo - http://www.websocket.org/echo.html
    if (host == 'local') host = '127.0.0.1';

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
          wsConn.send(JSON.stringify(jsonData));
      };

      // Close the connection.
      wsConn.onClosed = (int status, String reason) {
        print('Connection closed: Status - $status : Reason - $reason');
      };
    };

    _server.listen(host, port);
  }
}
