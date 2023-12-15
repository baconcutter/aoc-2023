import 'dart:io';
import 'dart:math';

final int ADD = 1000000 - 1;

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  Map<int, Point> galaxies = Map();
  List<(int, int)> galaxyPairs = [];

  var count = 1;
  int x = 0;
  int y = 0;
  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    if (lines[lineIndex].split('').every((e) => e == '.')) {
      y += ADD;
    }

    for (var colIndex = 0; colIndex < lines[0].length; colIndex++) {
      var column = lines.map((l) => l[colIndex]).toList();
      if (column.every((e) => e == '.')) {
        x += ADD;
      }

      if (lines[lineIndex][colIndex] == '#') {
        galaxyPairs.addAll(galaxies.keys.map((g) => (count, g)));
        galaxies.putIfAbsent(count, () => Point(colIndex + x, lineIndex + y));
        count++;
      }
    }
    x = 0;
  }

  int sum = 0;
  for (var pair in galaxyPairs) {
    var a = galaxies[pair.$1]!;
    var b = galaxies[pair.$2]!;
    var xd = (a.x - b.x).abs();
    var yd = (a.y - b.y).abs();
    sum += (xd + yd).toInt();
  }

  print(sum);
}
