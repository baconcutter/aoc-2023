import 'dart:collection';
import 'dart:io';

void main() {
  var lines =
      new File('input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  Set<(int, int)> positions = Set();
  for (var r = 0; r < lines.length; r++) {
    for (var c = 0; c < lines[r].length; c++) {
      if (lines[r][c] == 'S') {
        positions.add((c, r));
      }
    }
  }

  // pt1(lines, positions);
  pt2(lines, positions);
}

void pt2(List<List<String>> lines, Set<(int, int)> positions) {
  int cols = lines[0].length;
  int rows = lines.length;

  int steps = 500;
  while (steps > 0) {
    steps--;
    Queue p = Queue.from(positions);
    Set<(int, int)> n = Set();

    while (p.isNotEmpty) {
      var (c, r) = p.removeFirst();
      //top
      if (lines[(r - 1) % rows][c % cols] != '#') {
        n.add((r - 1, c));
      }
      //right
      if (lines[r % rows][(c + 1) % cols] != '#') {
        n.add((r, c + 1));
      }

      //bottom
      if (lines[(r + 1) % rows][c % cols] != '#') {
        n.add((r + 1, c));
      }

      //left
      if (lines[r % rows][(c - 1) % cols] != '#') {
        n.add((r, c - 1));
      }
    }
    // print(n.length - positions.length);
    positions = n;
  }
  // print(positions);
  print(positions.length);
}

void pt1(List<List<String>> lines, Set<(int, int)> positions) {
  int steps = 64;
  int rightBound = lines[0].length - 1;
  int bottomBound = lines.length - 1;
  while (steps > 0) {
    steps--;
    Queue p = Queue.from(positions);
    Set<(int, int)> n = Set();

    while (p.isNotEmpty) {
      var (c, r) = p.removeFirst();
      //top
      if (r > 0 && lines[r - 1][c] != '#') {
        n.add((r - 1, c));
      }
      //right
      if (c < rightBound && lines[r][c + 1] != '#') {
        n.add((r, c + 1));
      }

      //bottom
      if (r < bottomBound && lines[r + 1][c] != '#') {
        n.add((r + 1, c));
      }

      //left
      if (c > 0 && lines[r][c - 1] != '#') {
        n.add((r, c - 1));
      }
    }
    // print(n.length - positions.length);
    positions = n;
  }
  print(positions.length);
}
