// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * A simple waveform generator.
 *
 */
//Generate square wave
Sequence square([num cycles = 1, num amp = 1])
    => new _Waves().generate('square', cycles, amp);

//Generate triangle wave
Sequence triangle([num cycles = 1, num amp = 1])
    => new _Waves().generate('triangle', cycles, amp);

//Generate ramp wave
Sequence ramp([num cycles = 1, num amp = 1])
    => new _Waves().generate('ramp', cycles, amp);

//Generate pulse wave
Sequence pulse([num cycles = 1, num amp = 1])
    => new _Waves().generate('pulse', cycles, amp);

class _Waves {
  final points;
  Sequence data, mark, space, trise, tfall;
  var minAmp, tr, tf;

  _Waves()
      : points = 512,
        data = sequence([]),
        mark = sequence([]),
        space = sequence([]),
        trise = sequence([]),
        tfall = sequence([]),
        minAmp = 0;

  Sequence generate(String waveform, num cycles, num amp) {
    if (cycles > 4) {
      print('Please enter number of cycles to be 4 or less');
      return null;
    } else {
      //Attempt a 5% edge rate if possible.
      var edge = (points / cycles) * 0.05;
      //Square wave generator.
      if (waveform == 'square') {
        tr = edge > 4 ? edge.floor().toInt() : 4;
        tf = edge > 4 ? edge.floor().toInt() : 4;
        space.addAll(new List.filled(((points / (2 * cycles)).floor().toInt()) - tr, minAmp));
        mark.addAll(new List.filled(((points / (2 * cycles)).floor().toInt()) - tf, amp));
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      //Triangle wave generator.
      } else if (waveform == 'triangle') {
        tr = (points / (2 * cycles)).floor().toInt() - 1;
        tf = (points / (2 * cycles)).floor().toInt() - 1;
        space.addAll(new List.filled(1, minAmp));
        mark.addAll(new List.filled(1, amp));
        for (var j = 1; j <= tr; j++) {
          trise.add(((amp - minAmp) / tr) * j);
          tfall.add(amp - ((amp - minAmp) / tf) * j);
        }
      //Ramp generator.
      } else if (waveform == 'ramp') {
        tf = edge > 4 ? edge.floor().toInt() : 4;
        tr = (points / (cycles)).floor().toInt() - tf - 2;
        space.addAll(new List.filled(1, minAmp));
        mark.addAll(new List.filled(1, amp));
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
        space.addAll(new List.filled((9 * (points / (10 * cycles)).floor().toInt()) - tr, minAmp));
        mark.addAll(new List.filled(((points / (10 * cycles)).floor().toInt()) - tf, amp));
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
        data.addAll(new List.filled(points - data.length, minAmp));
      }
    }
    return data;
  }
}