/* *************************************************************** *
 *   Unit testing of fft and ifft algorithm                        *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */
void fftTests() {
  FFTResults x, y;
  // Constant factor fudge for small values of N with ifft.
  int cf = 2;
  /* This group tests the radix-2 fast fourier transform */
  group('Fast Fourier Transform algorithm tests: Radix-2:', () {
    List<int> samples = [0, 1, 2, 3];
    test('fft of a simple real value list with length power of 2', () {
      List<Complex> auData = [complex(6, 0),
                              complex(-2, 2),
                              complex(-2, 0),
                              complex(-2, -2)];
      y = fft(samples);
      for (var i = 0; i < y.data.length; i++) {
        y.data[i] = y.data[i].cround2;
      };
      expect(y.data, equals(auData));
      // Check less than O(n*n).
      expect(y.value, lessThan(samples.length * samples.length));
    });
    test('ifft of a simple real value list with length power of 2', () {
      List<Complex> auData = [complex(0, 0),
                              complex(1, 0),
                              complex(2, 0),
                              complex(3, 0)];
      x = ifft(y.data);
      for (var i = 0; i < x.data.length; i++) {
        x.data[i] = x.data[i].cround2;
      };
      expect(x.data, equals(auData));
      // Check less than O(n*n).  For small values of N,
      // this is unlikely to be true for ifft.  Need a better test.
      // We've added a constant factor fudge for the time being.
      expect(x.value, lessThan(cf * samples.length * samples.length));
    });
  });

  /* This group tests the discrete fourier transform */
  group('Fast Fourier Transform algorithm tests: DFT:', () {
    List<int> samples = [0, 1, 2, 3, 4, 5];
    test('fft of a simple real value list of arbitrary length', () {
      List<Complex> auData = [complex(15, 0),
                              complex(-3, 5.2),
                              complex(-3, 1.73),
                              complex(-3, 0),
                              complex(-3, -1.73),
                              complex(-3, -5.2)];
      y = fft(samples);
      for (var i = 0; i < y.data.length; i++) {
        y.data[i] = y.data[i].cround2;
      };
      expect(y.data, equals(auData));
      // Check equal to or more than O(n*n).
      expect(y.value, greaterThanOrEqualTo(samples.length * samples.length));
    });
    test('ifft of a simple real value list of arbitrary length', () {
      List<Complex> auData = [complex(0, 0),
                              complex(1, 0),
                              complex(2, 0),
                              complex(3, 0),
                              complex(4, 0),
                              complex(5, 0)];
      x = ifft(y.data);
      for (var i = 0; i < x.data.length; i++) {
        x.data[i] = x.data[i].cround2;
      };
      expect(x.data, equals(auData));
      // Check equal to or more than O(n*n).
      expect(x.value, greaterThanOrEqualTo(samples.length * samples.length));
    });
  });

  /* This group tests user defined value of N where N is a power of 2*/
  group('Fast Fourier Transform algorithm tests: User defined N:', () {
    var points = 4;
    test('fft of a simple real value list with truncation', () {
      List<int> samples = [0, 1, 2, 3, 4, 5];
      List<Complex> auData = [complex(6, 0),
                              complex(-2, 2),
                              complex(-2, 0),
                              complex(-2, -2)];
      y = fft(samples, points);
      for (var i = 0; i < y.data.length; i++) {
        y.data[i] = y.data[i].cround2;
      };
      expect(y.data, equals(auData));
      // Check less than O(n*n).
      expect(y.value, lessThan(points * points));
    });
    test('ifft of a simple real value list with truncated fft', () {
      List<Complex> auData = [complex(0, 0),
                              complex(1, 0),
                              complex(2, 0),
                              complex(3, 0)];
      x = ifft(y.data);
      for (var i = 0; i < x.data.length; i++) {
        x.data[i] = x.data[i].cround2;
      };
      expect(x.data, equals(auData));
      // Check less than O(n*n).  For small values of N,
      // this is unlikely to be true for ifft.  Need a better test.
      // We've added a constant factor fudge for the time being.
      expect(x.value, lessThan(cf * points * points));
    });
  });

  /* This group tests user defined value of N where N is not a power of 2*/
  group('Fast Fourier Transform algorithm tests: DFT: User defined N:', () {
    var points = 6;
    test('fft of a simple real value list with padding', () {
      List<int> samples = [0, 1, 2, 3];
      List<Complex> auData = [complex(6, 0),
                              complex(-3.5, -2.6),
                              complex(1.5, 0.87),
                              complex(-2, 0),
                              complex(1.5, -0.87),
                              complex(-3.5, 2.6)];
      y = fft(samples, points);
      for (var i = 0; i < y.data.length; i++) {
        y.data[i] = y.data[i].cround2;
      };
      expect(y.data, equals(auData));
      // Check equal to or more than O(n*n).
      expect(y.value, greaterThanOrEqualTo(points * points));
    });
    test('ifft of a simple real value list with padded fft', () {
      List<Complex> auData = [complex(0, 0),
                              complex(1, 0),
                              complex(2, 0),
                              complex(3, 0),
                              complex(0, 0),
                              complex(0, 0)];
      x = ifft(y.data);
      for (var i = 0; i < x.data.length; i++) {
        x.data[i] = x.data[i].cround2;
      };
      expect(x.data, equals(auData));
      // Check equal to or more than O(n*n).
      expect(x.value, greaterThanOrEqualTo(points * points));
    });
  });
}
