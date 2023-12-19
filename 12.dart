import 'dart:io';
import 'utils.dart';

void main() {
  var lines = new File('input.txt').readAsLinesSync();
  RegExp r = RegExp(r'\?');

  int sum = 0;

  lines.forEach((line) {
    var [record, goal] = line.split(' ');
    var goals = goal.split(',').map((e) => int.parse(e)).toList();

    // var record5 = record;
    // var goal5 = [...goals];
    // for (var i = 0; i < 4; i++) {
    //   record5 += '?' + record;
    //   goal5.addAll(goals);
    // }
    // print(record5);
    // print(goal5);

    



    var allMatches = r.allMatches(record);
    List<String> p = [record];

    print(record);
    // allMatches.forEach((m) {
    //   List<String> newP = [];
    //   for (var i = 0; i < p.length; i++) {
    //     newP.add(replaceCharAt(p[i], m.start, '#'));
    //     newP.add(replaceCharAt(p[i], m.start, '.'));
    //   }
    //   p = newP;
    // });

    // sum += p.where((element) => isValid(element, goals)).length;
  });
  print(sum);
}

// '#.##.###', [1,2,3]
bool isValid(String s, List<int> goal) {
  RegExp r = RegExp(r'(#+)');
  Iterable<Match> allMatches = r.allMatches(s);
  if (allMatches.length != goal.length) {
    return false;
  }
  for (var i = 0; i < allMatches.length; i++) {
    Match match = allMatches.elementAt(i);
    if (match[0]!.length != goal[i]) {
      return false;
    }
  }
  return true;
}
