import 'dart:io';
import 'dart:math';

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  partOne(lines);
  partTwo(lines);
}

void partOne(Iterable<String> lines) {
  int sum = 0;
  RegExp possibleParts = RegExp(r'(\d+)');
  for (var i = 0; i < lines.length; i++) {
    var allMatches = possibleParts.allMatches(lines.elementAt(i));

    for (var x = 0; x < allMatches.length; x++) {
      var match = allMatches.elementAt(x);
      var string = match[0].toString();
      var matchIndex = match.start;

      var startLineIndex = max(i - 1, 0);
      var endLineIndex = min(i + 1, lines.length - 1);
      var startIndex = max(matchIndex - 1, 0);
      var endIndex =
          min(matchIndex + string.length, lines.elementAt(i).length - 1);
      var adjacentSymbol = hasAdjacentSymbol(
          lines, startLineIndex, endLineIndex, startIndex, endIndex);

      if (adjacentSymbol) {
        sum += int.parse(string);
      }
    }
  }
  print(sum);
}

void partTwo(Iterable<String> lines) {
  RegExp gears = RegExp(r'(\*)');
  int sum = 0;
  for (var i = 0; i < lines.length; i++) {
    var allMatches = gears.allMatches(lines.elementAt(i));
    for (var x = 0; x < allMatches.length; x++) {
      var match = allMatches.elementAt(x);
      var string = match[0].toString();
      var matchIndex = match.start;
      var startLineIndex = max(i - 1, 0);
      var endLineIndex = min(i + 1, lines.length - 1);
      print('$string $matchIndex');
      sum += findGearRatio(lines, startLineIndex, endLineIndex, matchIndex);
    }
  }
  print(sum);
}

int findGearRatio(Iterable<String> lines, int startLineIndex, int endLineIndex,
    int gearIndex) {
  RegExp possibleParts = RegExp(r'(\d+)');
  List<String> gears = [];

  for (var i = startLineIndex; i <= endLineIndex; i++) {
    var allMatches = possibleParts.allMatches(lines.elementAt(i));
    for (var match in allMatches) {
      if (match.start - 1 == gearIndex ||
          match.start == gearIndex ||
          match.start + 1 == gearIndex ||
          match.end - 1 == gearIndex ||
          match.end == gearIndex) {
        gears.add(match[0].toString());
      }
    }
  }
  if (gears.length == 2) {
    return int.parse(gears[0]) * int.parse(gears[1]);
  }
  return 0;
}

bool hasAdjacentSymbol(Iterable<String> lines, int startLineIndex,
    int endLineIndex, int startIndex, int endIndex) {
  for (var i = startLineIndex; i <= endLineIndex; i++) {
    for (var x = startIndex; x <= endIndex; x++) {
      var char = lines.elementAt(i)[x];
      if (int.tryParse(char) == null && char != '.') {
        print(char);
        return true;
      }
    }
  }
  return false;
}
