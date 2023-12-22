import 'dart:io';

class Brick {
  int id;
  List<(int, int, int)> parts;
  List<Brick> supports = [];
  bool vertical;
  bool canBeRemoved = true;

  Brick(this.id, this.parts, this.vertical);

  @override
  String toString() {
    return '$id, parts ${parts}, supports: ${supports.map((e) => e.id)}';
  }

  void addSupport(Brick b) {
    supports.add(b);
  }

  void moveDown() {
    parts = parts.map((e) => (e.$1, e.$2, e.$3 - 1)).toList();
    // print('move $id down to ${parts}');
  }

  void cannotBeRemoved() {
    canBeRemoved = false;
  }
}

void main() {
  List<Brick> bricks = parse();

  settle(bricks);

  pt1(bricks);
  pt2(bricks);
}

List<Brick> parse() {
  var lines = new File('input.txt')
      .readAsLinesSync()
      .map((e) => e
          .split('~')
          .map((e) => e.split(',').map((e) => int.parse(e)).toList()))
      .toList();

  List<Brick> bricks = [];
  for (var b = 0; b < lines.length; b++) {
    var [x1, y1, z1] = lines.elementAt(b).first;
    var [x2, y2, z2] = lines.elementAt(b).last;
    List<(int, int, int)> parts = [];
    bool vertical = false;
    if (x2 - x1 > 0) {
      for (var i = x1; i <= x2; i++) {
        parts.add((i, y1, z1));
      }
    } else if (y2 - y1 > 0) {
      for (var i = y1; i <= y2; i++) {
        parts.add((x1, i, z1));
      }
    } else {
      for (var i = z1; i <= z2; i++) {
        vertical = true;
        parts.add((x1, y1, i));
      }
    }

    Brick brick = Brick(b, parts, vertical);
    bricks.add(brick);
  }
  return bricks;
}

void settle(List<Brick> bricks) {
  // settle from the bottom up
  bricks.sort((a, b) => a.parts.first.$3 - b.parts.first.$3);

  for (var i = 0; i < bricks.length; i++) {
    Brick brick = bricks[i];
    if (brick.parts.first.$3 != 1) {
      bool canMoveDown = true;
      while (canMoveDown) {
        Set<(int, int, int)> search =
            (brick.vertical ? [brick.parts.first] : brick.parts)
                .map((e) => (e.$1, e.$2, e.$3 - 1))
                .toSet();

        List<Brick> sublist = bricks.sublist(0, i + 1);
        var supporters = sublist.where(
            (element) => element.parts.toSet().intersection(search).length > 0);
        if (supporters.length > 0) {
          canMoveDown = false;
          supporters.forEach((s) {
            s.addSupport(brick);
          });
        } else {
          brick.moveDown();
          if (brick.parts.first.$3 == 1) {
            canMoveDown = false;
          }
        }
      }
    }
  }
}

void pt2(List<Brick> bricks) {
  int sum = 0;
  bricks.where((b) => !b.canBeRemoved).forEach((b) {
    // print('remove brick ${b.id}');
    var others = bricksOnSameLevel(bricks, b);
    var bricksToBeRemoved = b.supports.where(
        (s) => others.where((other) => other.supports.contains(s)).length == 0);

    sum += removeBricks(bricks, bricksToBeRemoved, 0);
  });
  print('pt2 $sum');
}

int removeBricks(List<Brick> bricks, Iterable<Brick> bricksToBeRemoved, int i) {
  int sum = i + bricksToBeRemoved.length;

  if (bricksToBeRemoved.isNotEmpty) {
    var supportedBricks =
        bricksToBeRemoved.map((b) => b.supports).expand((s) => s).toSet();
    var copy = List.of(bricks);
    bricksToBeRemoved.forEach((element) {
      // print('-> remove brick ${element.id}');
      copy.remove(element);
    });

    var unsupportedBricks = supportedBricks
        .where((element) => copy.every((b) => !b.supports.contains(element)));
    sum = removeBricks(copy, unsupportedBricks, sum);
  }
  return sum;
}

void pt1(List<Brick> bricks) {
  int sum = 0;
  bricks.forEach((brick) {
    // print(brick);
    if (brick.supports.isEmpty) {
      print('can be removed -> supports nothing');
      sum++;
    } else {
      // check bricks on same level.
      var otherBricksOnSameLevel = bricksOnSameLevel(bricks, brick);
      var canBeRemoved = brick.supports.every((s) =>
          otherBricksOnSameLevel
              .where((other) => other.supports.contains(s))
              .length >
          0);
      if (canBeRemoved) {
        // print('can be removed -> supported bricks are also supported by other bricks');
        sum++;
      } else {
        brick.cannotBeRemoved();
        // print('cannot be removed');
      }
    }
  });

  print('pt1 $sum');
}

List<Brick> bricksOnSameLevel(List<Brick> bricks, Brick brick) {
  return bricks
      .where((element) =>
          element.id != brick.id &&
          element.parts.where((part) => part.$3 == brick.parts.last.$3).length >
              0)
      .toList();
}
