import 'dart:math';

RegExp getNumbersRegExp = RegExp(r'(-?\d+)');
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

int leastCommonMultiple(int a, int b) {
  if ((a == 0) || (b == 0)) {
    return 0;
  }
  return ((a ~/ a.gcd(b)) * b).abs();
}

Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables) sync* {
  if (iterables.isEmpty) return;
  final iterators = iterables.map((e) => e.iterator).toList(growable: false);
  while (iterators.every((e) => e.moveNext())) {
    yield iterators.map((e) => e.current).toList(growable: false);
  }
}
