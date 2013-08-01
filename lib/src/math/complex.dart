// Copyright (c) 2013, scribeGriff (Richard Griffith)

part of convolab;

/**
 * A class for working with complex numbers.
 *
 * The complex number:
 *     complex(1, 2)
 * is equivalent to 1 + 2j.
 */

// Wrapper to illiminate need for using new/const keyword.
Complex complex(num a, [num b = 0]) => new Complex(a, b);

// Complex class
class Complex {
  final num real, imag;
  final int sigDig;

  const Complex(this.real, this.imag)
      : sigDig = 2;

  // Getters
  String  get string    => _compToString();
  num     get magnitude => math.sqrt(real*real + imag*imag);
  num     get phase     => math.atan2(imag, real);
  Complex get cround2   => _calcCompRound2();
  Complex get conj      => new Complex(real, -imag);
  Complex get recip     => _calcReciprocal();
  Complex get cexp      => new Complex(math.exp(real) * math.cos(imag),
      math.exp(real) * math.sin(imag));
  Complex get csin      => new Complex(math.sin(real) * cosh(imag),
      math.cos(real) * sinh(imag));
  Complex get ccos      => new Complex(math.cos(real) * cosh(imag),
      -math.sin(real) * sinh(imag));
  Complex get ctan      => csin / ccos;

  // Convert complex number to string.
  String _compToString() {
    if (imag.round() == 0) return "${real.toStringAsFixed(sigDig)}";
    if (real.round() == 0) return "${imag.toStringAsFixed(sigDig)}j";
    if (imag <  0) { return "${real.toStringAsFixed(sigDig)} - "
        "${imag.abs().toStringAsFixed(sigDig)}j";
    }
    return "${real.toStringAsFixed(sigDig)} + "
        "${imag.toStringAsFixed(sigDig)}j";
  }

  // Calculate complex reciprical.
  Complex _calcReciprocal() {
    num _magSquared = (real*real + imag*imag);
    return new Complex(real/_magSquared, -imag/_magSquared);
  }

  // Round fractional part of complex number to 2 significant digits.
  Complex _calcCompRound2() {
    var real100 = (real * 100).round();
    var imag100 = (imag * 100).round();
    return new Complex(real100 / 100, imag100 / 100);
  }

  // Method: scale complex number by b.
  Complex scale(num b) => new Complex(b * real, b * imag);

  // overloaded operators
  Complex operator +(Complex b) {
    Complex a = this;
    num _re = a.real + b.real;
    num _im = a.imag + b.imag;
    return new Complex(_re, _im);
  }

  Complex operator -(Complex b) {
    Complex a = this;
    num _re = a.real - b.real;
    num _im = a.imag - b.imag;
    return new Complex(_re, _im);
  }

  Complex operator *(Complex b) {
    Complex a = this;
    num _re = a.real * b.real - a.imag * b.imag;
    num _im = a.real * b.imag + a.imag * b.real;
    return new Complex(_re, _im);
  }

  Complex operator /(Complex b) {
    Complex a = this;
    return a * b.recip;
  }

  int get hashCode {
    int result = 5;
    result = 89 * result + real.hashCode;
    result = 89 * result + imag.hashCode;
    return result;
  }

  bool operator ==(var b) {
    if (b is! Complex) return false;
    Complex a = this;
    return  a.real == b.real && a.imag == b.imag;
  }
}