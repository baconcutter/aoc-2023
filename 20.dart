import 'dart:collection';
import 'dart:io';

abstract class Module {
  Iterable<Command> process(String from, bool high);

  Iterable<String> getTo();

  void addInput(String name);
}

class FlipFlop extends Module {
  bool on = false;
  String name;
  List<String> outputs;
  Set<String> inputs = Set();

  FlipFlop(this.name, this.outputs);

  @override
  Iterable<Command> process(String from, bool high) {
    if (!high) {
      on = !on;
      return outputs.map((e) => new Command(name, e, on));
    }
    return List.empty();
  }

  @override
  Iterable<String> getTo() {
    return outputs;
  }

  @override
  void addInput(String name) {
    inputs.add(name);
  }

  @override
  String toString() {
    return '$name inputs ${inputs}, outputs: ${outputs}';
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

  @override
  void addInput(String name) {
    input.putIfAbsent(name, () => false);
  }

  @override
  Iterable<String> getTo() {
    return to;
  }

  @override
  String toString() {
    return '$name inputs ${input}, outputs: ${to}';
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

  @override
  void addInput(String name) {
    // TODO: implement addInput
  }
}

class Command {
  bool high;
  String from;
  String to;
  Command(this.from, this.to, this.high);

  @override
  String toString() {
    return '${from} -${high ? 'high' : 'low'} -> ${to}';
  }
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
  m.keys.forEach((mk) {
    m.keys.where((key) => m[key]!.getTo().contains(mk)).forEach((k) {
      m[mk]!.addInput(k);
    });
  });

  m.keys.forEach((k) {
    print(m[k].toString());
  });

  pt1(m);
}

void pt2(Map<String, Module> m, String key) {}

void pt1(Map<String, Module> m) {
  int requiredButtonPushes = 4;
  int sumLow = 0;
  int sumHigh = 0;
  print('---PT1----');
  while (requiredButtonPushes > 0) {
    Queue<Command> commands = Queue();
    commands.addAll(m['broadcaster']!.process('button', false));
    sumLow++;
    requiredButtonPushes--;
    while (commands.isNotEmpty) {
      Command c = commands.removeFirst();
      print(c.toString());
      if (c.high) {
        sumHigh++;
      } else {
        sumLow++;
      }

      if (m[c.to] != null) {
        commands.addAll(m[c.to]!.process(c.from, c.high));
      }
    }
    print('-------');
  }

  print(sumLow * sumHigh);
}
