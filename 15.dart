import 'dart:io';
import 'dart:math';

void main() {
  var line = new File('input.txt').readAsLinesSync()[0];

  print(line.split(',').map((e) => hash(e)).reduce((value, element) => value+element));

}

int hash(String line) {
  int c = 0;
  for (var i = 0; i < line.length; i++) {
    c += line.codeUnitAt(i);
    c *= 17;
    c = c % 256;
  }
  return c;
}