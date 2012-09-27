/* *********************************************************** *
 *   Example using the function fsps() to compute the Fourier  *
 *   series of a sound wave sample, perform a partial sum for  *
 *   3 different sets of harmonics, then output data to a file *
 *   and send the data to a websocket.                         *
 * *********************************************************** */

#import('../../lib/convolab.dart');

void main() {
  var waveform = sound(3);
  var kvals = [10, 40, 80];
  var fourier = fsps(waveform, kvals);
  if (fourier != null) {
    fourier.exportToWeb('local', 8080);
    fourier.exportToFile('local/data/fsps.txt');
    print('We have computed ${fourier.psums.length} Fourier series.');
    if (fourier.psums[kvals[0]].every(f(element) => element is Complex)) {
      print('The computed Fourier series is of type Complex.');
    } else {
      print('The computed Fourier series is not Complex.');
    }
  } else {
    print('There was an error computing the Fourier series');
  }
}
