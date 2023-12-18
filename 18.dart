import 'dart:io';
import 'dart:math';

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  part1(lines);

  part2(lines);
}

void part2(List<String> lines) {
  List<(int, int)> points = [(0, 0)];
  (int, int) curPoint = (0, 0);

  for (var line in lines) {
    var hex = line.split('#')[1].split(')')[0];
    var a = int.parse(hex.substring(0, 5), radix: 16);
    var d = int.parse(hex[5]);

    (int, int) nextPoint;
    if (d == 3) {
      nextPoint = (curPoint.$1, curPoint.$2 - a);
    } else if (d == 0) {
      nextPoint = (curPoint.$1 + a, curPoint.$2);
    } else if (d == 1) {
      nextPoint = (curPoint.$1, curPoint.$2 + a);
    } else {
      nextPoint = (curPoint.$1 - a, curPoint.$2);
    }
    points.add(nextPoint);
    curPoint = nextPoint;
  }

  int diff = 0;
  (int, int) p = points[0];
  for (var i = 1; i < points.length; i++) {
    diff += (points[i].$1 - p.$1 + points[i].$2 - p.$2).abs();
    p = points[i];
  }

  print(polygonArea(points) + diff / 2 + 1);
}

void part1(List<String> lines) {
  List<(int, int)> points = [(0, 0)];
  (int, int) curPoint = (0, 0);

  for (var i = 0; i < lines.length; i++) {
    var [direction, nr, _] = lines[i].split(' ');
    (int, int) nextPoint;
    if (direction == 'U') {
      nextPoint = (curPoint.$1, curPoint.$2 - int.parse(nr));
    } else if (direction == 'R') {
      nextPoint = (curPoint.$1 + int.parse(nr), curPoint.$2);
    } else if (direction == 'D') {
      nextPoint = (curPoint.$1, curPoint.$2 + int.parse(nr));
    } else {
      nextPoint = (curPoint.$1 - int.parse(nr), curPoint.$2);
    }
    points.add(nextPoint);
    curPoint = nextPoint;
  }

  int diff = 0;
  (int, int) p = points[0];
  for (var i = 1; i < points.length; i++) {
    diff += (points[i].$1 - p.$1 + points[i].$2 - p.$2).abs();
    p = points[i];
  }

  print(polygonArea(points) + diff / 2 + 1);
}

double polygonArea(List<(int, int)> points) {
  var l = points.length;
  var det = 0;

  if (points[0] != points[points.length - 1]) points.add(points[0]);

  for (var i = 0; i < l - 1; i++)
    det += points[i].$1 * points[i + 1].$2 - points[i].$2 * points[i + 1].$1;
  return det.abs() / 2;
}
