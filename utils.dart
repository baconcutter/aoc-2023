import 'dart:math';

RegExp getNumbersRegExp = RegExp(r'(\d+)');
RegExp hasRepeatsRegExp = RegExp(r'(.).*\1');
RegExp hasRepeatedWordsRegExp = RegExp(r'(\w+).*\1');

List<int> getNumbersFromString(String s) => getNumbersRegExp
    .allMatches(s)
    .map((e) => int.parse(e[0].toString()))
    .toList();

bool hasRepeatedCharacters(String s) => hasRepeatsRegExp.hasMatch(s);
bool hasRepeatedWords(String s) => hasRepeatedWordsRegExp.hasMatch(s);

bool isAdjacent(Point a, Point b) =>
    (a.x - b.x).abs() <= 1 && (a.y - b.y).abs() <= 1;
bool sameRow(Point a, Point b) => a.y == b.y;
bool sameColumn(Point a, Point b) => a.x == b.x;
