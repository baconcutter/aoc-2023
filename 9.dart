import 'dart:io';
import 'utils.dart';

void main() {
  final lines = new File('input.txt').readAsLinesSync();

  var sumNext = 0;
  var sumPrev = 0;

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    List<List<int>> history = [getNumbersFromString(line)];
    var idx = 0;
    while (true) {
      List<int> next = [];
      var historyLine = history[idx];
      for (var x = 0; x < historyLine.length - 1; x++) {
        var a = history[idx][x];
        var b = history[idx][x + 1];
        next.add(b - a);
      }
      history.add(next);
      if (next.every((element) => element == 0)) {
        break;
      }
      idx++;
    }

    var nextValAdd = 0;
    var prevValMin = 0;
    for (var x = history.length - 1; x >= 0; x--) {
      var nextVal = history[x][history[x].length - 1] + nextValAdd;
      var prevVal = history[x][0] - prevValMin;
      history[x].add(nextVal);
      history[x] = [prevVal, ...history[x]];
      nextValAdd = nextVal;
      prevValMin = prevVal;
    }
    sumNext += nextValAdd;
    sumPrev += prevValMin;
  }

  print(sumNext);
  print(sumPrev);
}
