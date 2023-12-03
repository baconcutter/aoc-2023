import 'dart:io';
import 'dart:math';

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  partOne(lines);
}

void partOne(Iterable<String> lines) {
  int possibleGames = 0;
  int powers = 0;
  lines.forEach((line) {
    var parseLine2 = parseLine(line);
    possibleGames += parseLine2.$1;
    powers += parseLine2.$2;
  });
  print(possibleGames);
  print(powers);
}

(int, int) parseLine(String line) {
  var indexGame = line.split(':');
  int possibleGame = int.parse(indexGame[0].split(' ')[1]);
  var sets = indexGame[1].split(';');
  var red = 0;
  var green = 0;
  var blue = 0;
  sets.forEach((set) {
    var parts = set.split(',');
    parts.forEach((part) {
      var cubeNrAndColor = part.trim().split(' ');
      var nr = int.parse(cubeNrAndColor[0]);
      if (cubeNrAndColor[1] == 'blue') {
        blue = max(blue, nr);
        if (nr > 14) {
          possibleGame = 0;
        }
      }
      if (cubeNrAndColor[1] == 'green') {
        green = max(green, nr);
        if (nr > 13) {
          possibleGame = 0;
        }
      }
      if (cubeNrAndColor[1] == 'red') {
        red = max(red, nr);
        if (nr > 12) {
          possibleGame = 0;
        }
      }
    });
  });
  return (possibleGame, red * green * blue);
}
