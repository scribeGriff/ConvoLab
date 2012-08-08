/* ****************************************************** *
 *   FFTResults extends standard results class         *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class FFTResults extends ConvoLabResults {
  // Return input as Complex list.
  final List<Complex> input;

  FFTResults(List<Complex> data, int value, this.input) : super(data, value);

  // Method: display the results as a string.
  void show() => this.data.forEach((element) => print(element.string));
}
