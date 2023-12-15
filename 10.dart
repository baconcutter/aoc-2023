import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'utils.dart';

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  var bottomBound = lines.length - 1;
  var rightBound = lines[0].length - 1;

  Point start = new Point(0, 0);
  Map<Point, int> visited = new Map();

  for (var i = 0; i < lines.length; i++) {
    var s = lines[i].indexOf('S');
    if (s > -1) {
      start = new Point(s, i);
      visited.putIfAbsent(start, () => 0);
    }
  }

  Point s1 = start;
  Point s2 = start;
  int steps = 1;
  while (true) {
    List<Point?> pointsS1 = [
      s1.x - 1 < 0 ? null : new Point(s1.x - 1, s1.y), // left
      s1.x + 1 > rightBound ? null : new Point(s1.x + 1, s1.y), //right
      s1.y - 1 < 0 ? null : new Point(s1.x, s1.y - 1), // top
      s1.y + 1 > bottomBound ? null : new Point(s1.x, s1.y + 1) // bottom
    ];
    List<Point?> pointsS2 = [
      s2.x - 1 < 0 ? null : new Point(s2.x - 1, s2.y), // left
      s2.x + 1 > rightBound ? null : new Point(s2.x + 1, s2.y), //right
      s2.y - 1 < 0 ? null : new Point(s2.x, s2.y - 1), // top
      s2.y + 1 > bottomBound ? null : new Point(s2.x, s2.y + 1) // bottom
    ];

    Point? next1 = null;
    for (var to in pointsS1) {
      if (to != null &&
          isReachable(s1, to, lines) &&
          !visited.keys.contains(to)) {
        next1 = to;
        break;
      }
    }
    if (next1 != null) {
      visited.putIfAbsent(next1, () => steps);
      s1 = next1;
    } else {
      break;
    }

    Point? next2 = null;

    for (var to in pointsS2) {
      if (to != null &&
          isReachable(s2, to, lines) &&
          !visited.keys.contains(to)) {
        next2 = to;
        break;
      }
    }

    if (next2 != null) {
      visited.putIfAbsent(next2, () => steps);
      s2 = next2;
    } else {
      break;
    }
    steps++;
  }
  // print(visited);
  // print(steps);

}

bool isReachable(Point from, Point? to, List<String> lines) {
  if (to == null) {
    return false;
  }
  String a = lines[from.y.toInt()][from.x.toInt()];
  String b = lines[to.y.toInt()][to.x.toInt()];

  if (b == '.') {
    return false;
  }

  if (to.x - from.x == 1) {
    // right
    if (b == '|' || b == 'L' || b == 'F') {
      return false;
    }
    return a == '-' || a == 'L' || a == 'F' || a == 'S';
  }
  if (to.x - from.x == -1) {
    // left
    if (b == '|' || b == 'J' || b == '7') {
      return false;
    }
    return a == '-' || a == 'J' || a == '7' || a == 'S';
  }

  if (to.y - from.y == -1) {
    // top
    if (b == '-' || b == 'L' || b == 'J') {
      return false;
    }
    return a == '|' || a == 'J' || a == 'L' || a == 'S';
  }

  if (to.y - from.y == 1) {
    // bottom
    if (b == '-' || b == '7' || b == 'F') {
      return false;
    }
    return a == '|' || a == 'F' || a == '7' || a == 'S';
  }

  return false;
}
