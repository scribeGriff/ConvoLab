/* ****************************************************** *
 *   Class _Waves: A simple waveform generator.           *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */
//TODO needs some cleanup and error handling.
//Generate voice wave
ConvoLabResults sound([num cycles = 1, num amp = 1])
    => new _Waves().generate('sound', cycles, amp);

//Generate square wave
ConvoLabResults square([num cycles = 1, num amp = 1])
    => new _Waves().generate('square', cycles, amp);

//Generate triangle wave
ConvoLabResults triangle([num cycles = 1, num amp = 1])
    => new _Waves().generate('triangle', cycles, amp);

//Generate ramp wave
ConvoLabResults ramp([num cycles = 1, num amp = 1])
    => new _Waves().generate('ramp', cycles, amp);

//Generate pulse wave
ConvoLabResults pulse([num cycles = 1, num amp = 1])
    => new _Waves().generate('pulse', cycles, amp);

class _Waves {
  final points;
  List data, mark, space, trise, tfall;
  var minAmp, tr, tf;

  _Waves()
      : points = 512,
        data = [],
        mark = [],
        space = [],
        trise = [],
        tfall = [],
        minAmp = 0;

  ConvoLabResults generate(String waveform, num cycles, num amp) {
    //Sound sample.
    if (waveform == 'sound') {
      String filename = "external/data/sound$cycles.txt";
      data = new DoubleInputListHandler().prepareList(filename);
    } else {
      //Attempt a 5% edge rate if possible.
      var edge = (points / cycles) * 0.05;
      //Square wave generator.
      if (waveform == 'square') {
        tr = edge > 4 ? edge.floor().toInt() : 4;
        tf = edge > 4 ? edge.floor().toInt() : 4;
        space.insertRange(0, ((points / (2 * cycles)).floor().toInt()) - tr, minAmp);
        mark.insertRange(0, ((points / (2 * cycles)).floor().toInt()) - tf, amp);
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      //Triangle wave generator.
      } else if (waveform == 'triangle') {
        tr = (points / (2 * cycles)).floor().toInt() - 1;
        tf = (points / (2 * cycles)).floor().toInt() - 1;
        space.insertRange(0, 1, minAmp);
        mark.insertRange(0, 1, amp);
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      //Ramp generator.
      } else if (waveform == 'ramp') {
        tf = edge > 4 ? edge.floor().toInt() : 4;
        tr = (points / (cycles)).floor().toInt() - tf - 2;
        space.insertRange(0, 1, minAmp);
        mark.insertRange(0, 1, amp);
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
        }
        for (var j = 1; j <= tf; j++) {
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      //Pulse generator.
      } else if (waveform == 'pulse') {
        tr = edge > 4 ? edge.floor().toInt() : 4;
        tf = edge > 4 ? edge.floor().toInt() : 4;
        space.insertRange(0, (9 * (points / (10 * cycles)).floor().toInt()) - tr, minAmp);
        mark.insertRange(0, ((points / (10 * cycles)).floor().toInt()) - tf, amp);
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      }
      //Put the final waveform together.
      for (var i = 0; i < cycles; i++) {
        data
        ..addAll(space)
        ..addAll(trise)
        ..addAll(mark)
        ..addAll(tfall);
      }
      if (data.length < points) {
        data.insertRange(data.length, points - data.length, minAmp);
      }
    }
    return new ConvoLabResults(data, cycles);
  }
}
