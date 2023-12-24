import 'dart:io';

void main() {
  List<List<int>> grid = new File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();

  Set seen = Set();
  List<(int, int, int, int, int, int)> toBeSeen =
      List.from([(0, 0, 0, 0, 0, 0)]);

  while (toBeSeen.isNotEmpty) {
    var (heatLoss, x, y, deltaX, deltaY, directionTimes) = toBeSeen.removeAt(0);

    if (x == grid[0].length - 1 && y == grid.length - 1 && directionTimes >= 4) {
      print(heatLoss);
      break;
    }

    if (seen.contains((x, y, deltaX, deltaY, directionTimes))) {
      continue;
    }
    seen.add((x, y, deltaX, deltaY, directionTimes));

    if (directionTimes != 10 && (deltaX, deltaY) != (0, 0)) {
      int newX = x + deltaX;
      int newY = y + deltaY;
      if (newX >= 0 &&
          newX < grid[0].length &&
          newY >= 0 &&
          newY < grid.length) {
        toBeSeen.add((
          heatLoss + grid[newY][newX],
          newX,
          newY,
          deltaX,
          deltaY,
          directionTimes + 1
        ));
      }
    }

    if (directionTimes >= 4 || (deltaX, deltaY) == (0, 0)) {
      for (var (newDeltaX, newDeltaY) in [(0, 1), (1, 0), (0, -1), (-1, 0)]) {
        if ((newDeltaX, newDeltaY) != (deltaX, deltaY) &&
            (newDeltaX, newDeltaY) != (-deltaX, -deltaY)) {
          int newX = x + newDeltaX;
          int newY = y + newDeltaY;
          if (newX >= 0 &&
              newX < grid[0].length &&
              newY >= 0 &&
              newY < grid.length) {
            toBeSeen.add((
              heatLoss + grid[newY][newX],
              newX,
              newY,
              newDeltaX,
              newDeltaY,
              1
            ));
          }
        }
      }
    }

    toBeSeen.sort((a, b) => a.$1 - b.$1);
  }
}
