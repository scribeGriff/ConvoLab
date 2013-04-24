part of clabtests;

/* *************************************************************** *
 *   Unit testing of hyperbolic functions                          *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

void hyperbolicTests() {
  List<num> hbData = [0, 0.5, 1, 1.5, 2];
  List<num> sinhAu = [0, 0.5211, 1.1752, 2.12928, 3.62686];
  List<num> coshAu = [1, 1.12763, 1.54308, 2.35241, 3.7622];
  List<num> tanhAu = [0, 0.46212, 0.76159, 0.905148, 0.96403];
  List<num> cothAu = [1/0, 2.1640, 1.3130, 1.1048, 1.0373];

  List<num> sinhAc = new List();
  List<num> coshAc = new List();
  List<num> tanhAc = new List();
  List<num> cothAc = new List();

  //hyperbolic sine
  for (var x = 0; x < sinhAu.length; x++) {
    sinhAu[x] = (sinhAu[x]*10000).round();
  }
  for (var x = 0; x < hbData.length; x++) {
    sinhAc.add((sinh(hbData[x])*10000).round());
  }
  expect.listEquals(sinhAu, sinhAc);

  //hyperbolic cosine
  for (var x = 0; x < coshAu.length; x++) {
    coshAu[x] = (coshAu[x]*10000).round();
  }
  for (var x = 0; x < hbData.length; x++) {
    coshAc.add((cosh(hbData[x])*10000).round());
  }
  expect.listEquals(coshAu, coshAc);

  //hyperbolic tangent
  for (var x = 0; x < tanhAu.length; x++) {
    tanhAu[x] = (tanhAu[x]*10000).round();
  }
  for (var x = 0; x < hbData.length; x++) {
    tanhAc.add((tanh(hbData[x])*10000).round());
  }
  expect.listEquals(tanhAu, tanhAc);

  //hyperbolic cotangent
  for (var x = 0; x < cothAu.length; x++) {
    cothAu[x] = (cothAu[x]*10000).round();
  }
  for (var x = 0; x < hbData.length; x++) {
    cothAc.add((coth(hbData[x])*10000).round());
  }
  expect.listEquals(cothAu, cothAc);
}
