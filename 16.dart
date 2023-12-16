import 'dart:io';
import 'dart:math';

class Beam {
  int x;
  int y;
  String direction;

  Beam(this.x, this.y, this.direction);
}

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  int pt1 = calcEnergized(lines, 0, 0, 'right');
  print(pt1);

  int pt2 = 0;
  //from top | bottom
  for (var i = 0; i < lines[0].length; i++) {
    print('top|bottom $i');
    pt2 = max(pt2, calcEnergized(lines, i, 0, 'down'));
    pt2 = max(pt2, calcEnergized(lines, i, lines.length - 1, 'up'));
  }

  //from left | right
  for (var i = 0; i < lines.length; i++) {
    print('left | right $i');
    pt2 = max(pt2, calcEnergized(lines, 0, i, 'right'));
    pt2 = max(pt2, calcEnergized(lines, lines[0].length -1, i, 'left'));
  }
  print(pt2);
}

int calcEnergized(List<String> lines, int fromX, int fromY, String direction) {
  List<Beam> beams = [new Beam(fromX, fromY, direction)];
  Set<((int, int), String)> visited = Set();

  while (beams.isNotEmpty) {
    var list = List.of(beams);

    for (var beam in list) {
      if (visited.length > 1 &&
          visited
              .where((v) =>
                  v.$1.$1 == beam.x &&
                  v.$1.$2 == beam.y &&
                  v.$2 == beam.direction)
              .isNotEmpty) {
        beams.remove(beam);
        continue;
      }
      visited.add(((beam.x, beam.y), beam.direction));

      String encounter = lines[beam.y][beam.x];
      if (encounter == '.' ||
          (encounter == '-' &&
              (beam.direction == 'right' || beam.direction == 'left')) ||
          (encounter == '|' &&
              (beam.direction == 'up' || beam.direction == 'down'))) {
        // nothing
      } else if (encounter == '/') {
        if (beam.direction == 'up') {
          beam.direction = 'right';
        } else if (beam.direction == 'down') {
          beam.direction = 'left';
        } else if (beam.direction == 'left') {
          beam.direction = 'down';
        } else if (beam.direction == 'right') {
          beam.direction = 'up';
        }
      } else if (encounter == '\\') {
        if (beam.direction == 'up') {
          beam.direction = 'left';
        } else if (beam.direction == 'down') {
          beam.direction = 'right';
        } else if (beam.direction == 'left') {
          beam.direction = 'up';
        } else if (beam.direction == 'right') {
          beam.direction = 'down';
        }
      } else if (encounter == '|') {
        beam.direction = 'up';
        beams.add(new Beam(beam.x, beam.y, 'down'));
      } else if (encounter == '-') {
        beam.direction = 'left';
        beams.add(new Beam(beam.x, beam.y, 'right'));
      }

      // determine next coordinates.
      int nextX = beam.x;
      int nextY = beam.y;

      if (beam.direction == 'right') {
        nextX++;
      } else if (beam.direction == 'left') {
        nextX--;
      } else if (beam.direction == 'up') {
        nextY--;
      } else if (beam.direction == 'down') {
        nextY++;
      }

      // check bounds
      if (nextX < 0 ||
          nextX >= lines[0].length ||
          nextY < 0 ||
          nextY >= lines.length) {
        // remove beam
        beams.remove(beam);
        continue;
      }
      beam.x = nextX;
      beam.y = nextY;
    }
  }

  var set = visited.map((e) => (e.$1.$1, e.$1.$2)).toSet();
  return set.length;
}

void printVisited(List<String> lines, Set<((int, int), String)> visited) {
  print('');
  for (var l = 0; l < lines.length; l++) {
    String line = '';
    for (var i = 0; i < lines[l].length; i++) {
      var length = visited
          .where((element) => element.$1.$1 == i && element.$1.$2 == l)
          .length;

      if (length > 0) {
        // line += '$length';
        line += '#';
      } else {
        line += lines[l][i];
      }
    }
    print(line);
  }
}
