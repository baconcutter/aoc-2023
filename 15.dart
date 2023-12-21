import 'dart:io';
import 'dart:math';

void main() {
  var line = new File('input.txt').readAsLinesSync()[0];

  //pt1
  print(line
      .split(',')
      .map((e) => hash(e))
      .reduce((value, element) => value + element));

  List<List<(String, int)>> boxes = List.generate(256, (_) => []);

  line.split(',').map((e) {
    var splitted = e.split('=');
    if (splitted.length == 2) {
      return (splitted[0], hash(splitted[0]), int.parse(splitted[1]));
    } else {
      var substring = splitted[0].substring(0, splitted[0].length - 1);
      return (substring, hash(substring), null);
    }
  }).forEach((item) {
    List<(String, int)> box = boxes[item.$2];
    (String, int) existingLens = box
        .firstWhere((element) => element.$1 == item.$1, orElse: () => ('', -1));
    var lensIndex = box.indexOf(existingLens);    

    if (item.$3 == null) {
      if (lensIndex > -1) {
        box.remove(existingLens);
      }
    } else {
      if (lensIndex > -1) {
        box.replaceRange(lensIndex, lensIndex+1, [(item.$1, item.$3!)]);
      } else {
        box.add((item.$1, item.$3!));
      }
    }
  });

  

  double sum = 0;
  for (var i = 0; i < boxes.length; i++) {
    print('$i ${boxes[i]}');
    for (var x = 0; x < boxes[i].length; x++) {
      sum += (1+i) * (x+1) * boxes[i][x].$2;
    }
  }
  print(sum);
}

int hash(String line) {
  int c = 0;
  for (var i = 0; i < line.length; i++) {
    c += line.codeUnitAt(i);
    c *= 17;
    c = c % 256;
  }
  return c;
}
