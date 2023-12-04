import 'dart:io';

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  solve(lines);
}

void solve(Iterable<String> lines) {
  int sum = 0;
  List<int> cards = lines.map((e) => 1).toList();
  RegExp nrReg = RegExp(r'(\d+)');

  for (var i = 0; i < lines.length; i++) {
    var numbers = lines.elementAt(i).split(':')[1];
    var [winning, mynumbers] = numbers.split('|');
    var worth = 0;
    var allMatches = nrReg.allMatches(mynumbers);
    var winningNrs = 0;
    allMatches.forEach((nr) {
      var nrS = nr[0];
      if (winning.contains(' $nrS ')) {
        winningNrs++;
        worth = worth == 0 ? 1 : worth * 2;
      }
    });
    sum += worth;

    for (var x = 1; x <= winningNrs; x++) {
      cards[i + x]+= cards[i];
    }
  }
  ;

  print(sum);
  print(cards.reduce((value, element) => value+element));
}
