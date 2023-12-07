import 'dart:io';

final List<String> ALL_CARDS = [
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'J',
  'Q',
  'K',
  'A'
];

final List<String> ALL_CARDS_WITH_JOKER = [
  'J',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'Q',
  'K',
  'A'
];

void main() {
  final lines = new File('input.txt').readAsLinesSync();


  partOne(lines);
  partTwo(lines);
}

void partTwo(List<String> lines) {
  List<(String, String, int)> mapped = lines.map((line) {
    var [hand, score] = line.split(' ');

    String s = '';
    var cards = hand.split('');
    Map<String, int> cardMap = new Map();
    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      if (card != 'J') {
        cardMap.putIfAbsent(card, () => 0);
        cardMap.update(card, (value) => value + 1);
      }
      s += ALL_CARDS_WITH_JOKER.indexOf(card).toRadixString(16);
    }

    int jokers = cards.where((card) => card == 'J').length;
    if (jokers == 5) {
      cardMap.putIfAbsent('J', () => 5);
    } else if (jokers > 0) {
      var list = cardMap.entries.toList();
      list.sort((a, b) => b.value - a.value);
      cardMap.update(list[0].key, (value) => value + jokers);
    }

    int sum = calculateHandScore(cardMap);

    return (hand, score, int.parse(sum.toString() + s, radix: 16));
  }).toList();

  getSum(mapped);
}

void getSum(List<(String, String, int)> mapped) {
  mapped.sort((a, b) => a.$3 - b.$3);
  int sum = 0;
  for (var i = 0; i < mapped.length; i++) {
    sum += int.parse(mapped[i].$2) * (i + 1);
  }
  print(sum);
}

int calculateHandScore(Map<String, int> cardMap) {
  int sum = 0;
  cardMap.keys.forEach((key) {
    int occ = cardMap[key]!;
    if (occ == 5) {
      sum += 100;
    }
    if (occ == 4) {
      sum += 90;
    }
    if (occ == 3) {
      sum += 50;
    }
    if (occ == 2) {
      sum += 20;
    }
  });
  return sum;
}

void partOne(List<String> lines) {
  List<(String, String, int)> mapped = lines.map((line) {
    var [hand, score] = line.split(' ');

    String s = '';
    var cards = hand.split('');
    Map<String, int> cardMap = new Map();
    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      cardMap.putIfAbsent(card, () => 0);
      cardMap.update(card, (value) => value + 1);
      s += ALL_CARDS.indexOf(card).toRadixString(16);
    }
    int sum = calculateHandScore(cardMap);

    return (hand, score, int.parse(sum.toString() + s, radix: 16));
  }).toList();

  getSum(mapped);
}
