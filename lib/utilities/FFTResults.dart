/* ****************************************************** *
 *   FFTResults extends standard results class         *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class FFTResults extends ConvoLabResults {
  FFTResults(List<Complex> data, int value) : super(data, value);

  void show() => this.data.forEach((element) => print(element.string));
}
