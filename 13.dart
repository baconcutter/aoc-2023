import 'dart:io';

void main() {
  List<String> lines = new File('input.txt').readAsLinesSync();

  List<List<String>> groups = [];
  List<String> current = [];
  for (var line in lines) {
    if (line.isEmpty) {
      groups.add(current);
      current = [];
    } else {
      current.add(line);
    }
  }
  groups.add(current);

  // print(groups);

  int sum = 0;

  for (var group in groups) {
    // check rows
    var rowMirror = getMirror(group);

    // check cols
    List<String> cols = [];
    for (var i = 0; i < group[0].length; i++) {
      String col = '';
      for (var x = 0; x < group.length; x++) {
        col += group[x][i];
      }
      cols.add(col);
    }
    var colMirror = getMirror(cols);

    if (rowMirror >= colMirror) {
      sum += rowMirror * 100;
    } else {
      sum += colMirror;
    }

    if (rowMirror == 0 && colMirror == 0) {
      print('dafuq');
      group.forEach((element) => print(element));
      print('------');
      // print(group);
    }
  }
  print(sum);
}

int getMirror(List<String> group) {
  for (var i = 1; i < group.length; i++) {
    if (group[i] == group[i - 1]) {
      var above = group.getRange(0, i).toList().reversed.toList();
      var below = group.getRange(i, group.length).toList();

      if (above.length >= below.length) {
        above = above.getRange(0, below.length).toList();
      } else {
        below = below.getRange(0, above.length).toList();
      }

      if (above.join('') == below.join('')) {
        // print('$above :: $below');

        return i;
      }
    }
  }
  return 0;
}
