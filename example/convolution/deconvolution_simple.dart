/* *********************************************************** *
 *   Example using the function deconv() to compute the        *
 *   Deconvoution of two non-casual signals whose polynomial   *
 *   coefficients are defined in num and den and whose         *
 *   zero index is given by nindex and dindex.                 *
 * *********************************************************** */

import 'package:convolab/convolab.dart';

void main() {

  var nindex = 2;
  var dindex = 1;
  // num = z^2 + z + 1 + z^-1 + z^-2 +z^-3
  var num = [1, 1, 1, 1, 1, 1];
  // den = z + 2 + z^-1
  var den = [1, 2, 1];

  // Compute h = num / den and output quotient and remainder.
  var h = deconv(num, den, nindex, dindex);
  print('The quotient is ${h.q}');
  print('The remainder is ${h.r}');
  print(h.qtime);
  print(h.qindex);
  print(h.rtime);
  print(h.rindex);

  // Prints:
  // The quotient is [1, -1, 2, -2]
  // The remainder is [0, 0, 0, 0, 3, 3]
  // [-1, 0, 1, 2]
  // 1
  // [-2, -1, 0, 1, 2, 3]
  // 2
  //
  // This corresponds to the following result for h:
  // h = z - 1 + 2z^-1 - 2z^-2 + (3z^-2 + 3z^-3 / z + 2 + z^-1)
}