import 'dart:io';

RegExp nrReg = RegExp(r'(\d+)');
RegExp mapReg = RegExp(r'(\w+)\-to\-(\w+)');

void main() {
  final lines = new File('input.txt').readAsLinesSync();

  partOne(lines);
  partTwo(lines);
}

void partTwo(List<String> lines) {
  int time = concatNumbersFromLine(lines.elementAt(0));
  int recordDistance = concatNumbersFromLine(lines.elementAt(1));

  print(countPossibilities(time, recordDistance));
}

int countPossibilities(int time, int recordDistance) {
  int possible = 0;
  for (var x = 0; x < time; x++) {
    var travelTime = time - x;
    var distance = x * travelTime;
    if (distance > recordDistance) {
      possible++;
    }
  }
  return possible;
}


void partOne(List<String> lines) {
  var times = getNumbersFromString(lines.elementAt(0));
  var distances = getNumbersFromString(lines.elementAt(1));
  var sum = 1;

  for (var i = 0; i < times.length; i++) {
    var time = times[i];
    var recordDistance = distances[i];
    var possible = countPossibilities(time, recordDistance);
    if (possible > 0) {
      sum *= possible;
    }
  }

  print(sum);
}

List<int> getNumbersFromString(String s) {
  return nrReg.allMatches(s).map((e) => int.parse(e[0].toString())).toList();
}

int concatNumbersFromLine(String line) {
  return int.parse(getNumbersFromString(line)
      .map((e) => e.toString())
      .reduce((value, element) => '$value$element'));
}