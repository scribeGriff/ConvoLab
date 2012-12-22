/* *********************************************************** *
 *   Example using the function fsps() to compute the Fourier  *
 *   series of a triangle wave, perform a partial sum for 3    *
 *   different sets of harmonics for a period of half the      *
 *   length of the data, then output data to a file and send   *
 *   the data to a websocket.                                  *
 * *********************************************************** */

import 'package:convolab/convolab.dart';

void main() {
  var waveform = square(1);
  var kvals = [1, 16, 80];
  var fourier = fsps(waveform, kvals);
  if (fourier != null) {
    print('We have computed ${fourier.psums.length} Fourier series.');
    if (fourier.psums[kvals[0]].every((element) => element is Complex)) {
      print('The computed Fourier series is of type Complex.');
    } else {
      print('The computed Fourier series is not Complex.');
    }
  } else {
    print('There was an error computing the Fourier series');
  }
}
