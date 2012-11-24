/* *********************************************************** *
 *   Example using the function fsps() to compute the Fourier  *
 *   series of a sound wave sample, perform a partial sum for  *
 *   3 different sets of harmonics, then output data to a file *
 *   and send the data to a websocket.                         *
 * *********************************************************** */

import 'package:convolab/convolab.dart';

void main() {
  FftResults x, y;
  List<int> samples = [0, 1, 2, 3];
  y = fft(samples);
  if (y != null) {
    y.show();
    // prints:
    // 6.00
    // -2.00 + 2.00j
    // -2.00
    // -2.00 - 2.00j
    // Now compute the inverse fft:
    x = ifft(y.data);
    x.show("The inverse fft is:");
    // prints:
    // The inverse fft is:
    // 0.00
    // 1.00
    // 2.00
    // 3.00
  } else {
    print('There was an error computing the Fourier transform');
  }
}
