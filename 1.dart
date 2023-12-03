import 'dart:io';

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  partOne(lines);
  partTwo(lines);
}

void partTwo(List<String> lines) {
  List<String> mappedList = lines.map((e) => replaceNumbers(e)).toList();
  partOne(mappedList);
}

String replaceNumbers(String s) {
  return s
      .replaceAll(RegExp(r'one'), 'one1one')
      .replaceAll(RegExp(r'two'), 'two2two')
      .replaceAll(RegExp(r'three'), 'three3three')
      .replaceAll(RegExp(r'four'), 'four4four')
      .replaceAll(RegExp(r'five'), 'five5five')
      .replaceAll(RegExp(r'six'), 'six6six')
      .replaceAll(RegExp(r'seven'), 'seven7seven')
      .replaceAll(RegExp(r'eight'), 'eight8eight')
      .replaceAll(RegExp(r'nine'), 'nine9nine');
}

void partOne(Iterable<String> lines) {
  int sum = 0;
  lines.forEach((element) {
    sum += parseLine(element);
  });
  print(sum);
}

int parseLine(String element) {
  RegExp r = RegExp(r'(\d)');
  Iterable<RegExpMatch> matches = r.allMatches(element);
  return int.parse(matches.first[0]! + matches.last[0]!);
}
