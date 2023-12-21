import 'dart:io';
import 'dart:math';

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  int heatLoss = 0;
  List<Point> visited = [Point(0, 0)];
  Point position = Point(0, 0);
  Point destination = Point(lines[0].length - 1, lines.length - 1);

  while (position.distanceTo(destination) != 0) {
    //consider next two moves and take the one with the least heat loss
    // visited is not an option
    // if last two x has same x then also not an option.
    // if last two y has same y then also not an option.

    // top
    var top = Point(position.x, position.y - 1);
    var right = Point(position.x + 1, position.y);
    var down = Point(position.x, position.y + 1);
    var left = Point(position.x - 1, position.y);
  }
}

int calculate(Point from, List<Point> visited, List<String> lines, int sum) {
  if (from.x == lines[0].length - 1 && from.y == lines.length - 1) {
    return sum;
  }

  List<Point> nextPoints = [];

  List<Point> lastVisits = [];
  if (visited.length > 1) {
    lastVisits = visited.sublist(visited.length - 2);
  }

  var up = Point(from.x, from.y - 1);
  if (from.y != 0 &&
      !visited.contains(up) &&
      !lastVisits.every((element) => element.x == up.x)) {
    nextPoints.add(up);
  }

  var down = Point(from.x, from.y - 1);
  if (from.y != lines.length - 1 &&
      !visited.contains(down) &&
      !lastVisits.every((element) => element.x == down.x)) {
    nextPoints.add(down);
  }

  var left = Point(from.x - 1, from.y);
  if (from.x != 0 &&
      !visited.contains(left) &&
      !lastVisits.every((element) => element.y == left.y)) {
    nextPoints.add(left);
  }

  var right = Point(from.x + 1, from.y);
  if (from.x != lines[0].length - 1 &&
      !visited.contains(right) &&
      !lastVisits.every((element) => element.y == right.y)) {
    nextPoints.add(right);
  }

// add to sum
  // calculate next

  return sum;
}
