import 'dart:collection';
import 'dart:io';

abstract class Module {
  Iterable<Command> process(String from, bool high);

  Iterable<String> getTo();
}

class FlipFlop extends Module {
  bool on = false;
  String name;
  List<String> to;

  FlipFlop(this.name, this.to);

  @override
  Iterable<Command> process(String from, bool high) {
    if (!high) {
      on = !on;
      return to.map((e) => new Command(name, e, on));
    }
    return List.empty();
  }

  @override
  Iterable<String> getTo() {
    return to;
  }
}

class Conjuction extends Module {
  bool on = false;
  String name;
  List<String> to;
  Map<String, bool> input = Map();

  Conjuction(this.name, this.to);

  @override
  Iterable<Command> process(String from, bool high) {
    input[from] = high;
    var highInputs = input.keys.where((key) => input[key]!).length;
    bool highOutput = highInputs != input.keys.length;
    return to.map((e) => new Command(name, e, highOutput));
  }

  void addInput(String name) {
    input.putIfAbsent(name, () => false);
  }

  @override
  Iterable<String> getTo() {
    return to;
  }

  @override
  String toString() {
    return '$name ${input}';
  }
}

class Broadcaster extends Module {
  List<String> to;

  Broadcaster(this.to);

  @override
  Iterable<Command> process(String from, bool high) {
    return to.map((e) => new Command('broadcaster', e, high));
  }

  @override
  Iterable<String> getTo() {
    return to;
  }
}

class Command {
  bool high;
  String from;
  String to;
  Command(this.from, this.to, this.high);
}

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  Map<String, Module> m = Map();

  lines.forEach((line) {
    var [typeAndName, output] = line.split(' -> ');
    List<String> to = output.split(', ');

    if (typeAndName == 'broadcaster') {
      m.putIfAbsent(typeAndName, () => new Broadcaster(to));
    } else {
      String type = typeAndName[0];
      String name = typeAndName.substring(1);

      if (type == '%') {
        m.putIfAbsent(name, () => new FlipFlop(name, to));
      } else if (type == '&') {
        m.putIfAbsent(name, () => new Conjuction(name, to));
      } else {
        throw Exception('Unknown type $type');
      }
    }
  });

  // add inputs to conjuctions.
  m.keys.where((key) => m[key] is Conjuction).forEach((k) {
    Conjuction c = m[k] as Conjuction;
    m.keys.where((key) => m[key]!.getTo().contains(k)).forEach((k) {
      c.addInput(k);
    });
  });

  int requiredButtonPushes = 1000;
  int sumLow = 0;
  int sumHigh = 0;
  while (requiredButtonPushes > 0) {
    
    Queue<Command> commands = Queue();
    commands.addAll(m['broadcaster']!.process('button', false));
    sumLow++;
    requiredButtonPushes--;
    while (commands.isNotEmpty) {
      Command c = commands.removeFirst();
      // print('${c.from} -${c.high ? 'high' : 'low'} -> ${c.to}');
      if (c.high) {
        sumHigh++;
      } else {
        sumLow++;
      }

      if (m[c.to] != null) {
        commands.addAll(m[c.to]!.process(c.from, c.high));
      }

    }
    // print('------');
  }

  print(sumLow * sumHigh);
}
