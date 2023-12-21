import 'dart:io';

void main() {
  List<List<String>> lines =
      new File('input.txt').readAsLinesSync().map((e) => e.split('')).toList();

  // pt1(lines);

  for (var i = 0; i < 1000; i++) {
    goNorth(lines);
    goWest(lines);
    goSouth(lines);
    goEast(lines);
    print(calcLoadNorth(lines));
  }
}

void p(List<List<String>> lines) {
  lines.forEach((element) {
    print(element);
  });
  print('_______');
}

void pt1(List<List<String>> lines) {
  goNorth(lines);
  print(calcLoadNorth(lines));
}

int calcLoadNorth(List<List<String>> lines) {
  int sum = 0;
  for (var i = 0; i < lines.length; i++) {
    int load = lines.length - i;
    sum += lines[i].where((element) => element == 'O').length * load;
  }
  return sum;
}

void goNorth(List<List<String>> lines) {
  bool settled = false;
  while (settled == false) {
    settled = true;
    for (var i = 1; i < lines.length; i++) {
      var line = lines[i];
      var prevLine = lines[i - 1];
      for (var x = 0; x < line.length; x++) {
        if (line[x] == 'O' && prevLine[x] == '.') {
          settled = false;
          line[x] = '.';
          lines[i - 1][x] = 'O';
        }
      }
    }
  }
}

void goSouth(List<List<String>> lines) {
  bool settled = false;
  while (settled == false) {
    settled = true;
    for (var i = lines.length - 2; i >= 0; i--) {
      var line = lines[i];
      var nextLine = lines[i + 1];
      for (var x = 0; x < line.length; x++) {
        if (line[x] == 'O' && nextLine[x] == '.') {
          settled = false;
          line[x] = '.';
          nextLine[x] = 'O';
        }
      }
    }
  }
}

void goEast(List<List<String>> lines) {
  bool settled = false;
  while (settled == false) {
    settled = true;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      for (var x = lines.length - 2; x >= 0; x--) {
        if (line[x] == 'O' && line[x + 1] == '.') {
          settled = false;
          line[x] = '.';
          line[x + 1] = 'O';
        }
      }
    }
  }
}

void goWest(List<List<String>> lines) {
  bool settled = false;
  while (settled == false) {
    settled = true;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      for (var x = 0; x < line.length - 2; x++) {
        if (line[x] == '.' && line[x + 1] == 'O') {
          settled = false;
          line[x] = 'O';
          line[x + 1] = '.';
        }
      }
    }
  }
}
