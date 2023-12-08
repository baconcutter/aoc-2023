import 'dart:io';
import 'utils.dart';

void main() {
  final lines = new File('input.txt').readAsLinesSync();

  var instructions = lines[0].split('');
  Map<String, (String, String)> network = new Map();
  for (var i = 2; i < lines.length; i++) {
    var [node, lr] = lines[i].split(' = ');
    var [left, right] = lr.split(', ');
    network.putIfAbsent(node, () => (left.substring(1), right.substring(0, 3)));
  }

  partOne(instructions, network);
  partTwo(instructions, network);
}

void partTwo(List<String> instructions, Map<String, (String, String)> network) {
  List<String> curNodes =
      network.keys.where((element) => element.endsWith('A')).toList();

  var list = curNodes.map((e) => calc(e, instructions, network)).toList();
  var val = list.reduce((value, element) => leastCommonMultiple(value, element));

  print(val);
}

int calc(String curNode, List<String> instructions, Map<String, (String, String)> network){
  int instructionIndex = 0;
  int sum = 0;
  while (true) {
    if (curNode.endsWith('Z')) {
      break;
    }

    curNode = instructions[instructionIndex] == 'L'
        ? network[curNode]!.$1
        : network[curNode]!.$2;

    instructionIndex++;
    if (instructionIndex > instructions.length - 1) {
      instructionIndex = 0;
    }
    sum++;
  }
  return sum;
}

void partOne(List<String> instructions, Map<String, (String, String)> network) {
  int instructionIndex = 0;
  String curNode = 'AAA';
  int sum = 0;
  while (true) {
    if (curNode == 'ZZZ') {
      break;
    }

    curNode = instructions[instructionIndex] == 'L'
        ? network[curNode]!.$1
        : network[curNode]!.$2;

    instructionIndex++;
    if (instructionIndex > instructions.length - 1) {
      instructionIndex = 0;
    }
    sum++;
  }
  print(sum);
}

