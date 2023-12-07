import 'dart:io';
import 'dart:math';

import 'utils.dart';

RegExp nrReg = RegExp(r'(\d+)');
RegExp mapReg = RegExp(r'(\w+)\-to\-(\w+)');

void main() {
  final lines = new File('input.txt').readAsLinesSync();
  var map = parse(lines);

  var seedsPt1 = getNumbersFromString(lines[0]);
  print(getMinSource(seedsPt1, map));

  partTwo(lines);
}

void partTwo(List<String> lines) {
  var nrs = getNumbersFromString(lines[0]);
  List<(int, int)> seedRanges = [];
  for (var i = 0; i < nrs.length; i += 2) {
    seedRanges.add((nrs[i], nrs[i] + nrs[i + 1]));
  }

  var map = parse2(lines);

  // go through each category and try to map the ranges
  map.keys.forEach((key) {
    List<(int, int)> newSeedRanges = [];

    while (seedRanges.isNotEmpty) {
      var (start, end) = seedRanges.removeAt(0);
      bool hasOverlap = false;
      for (var (destinationRangeStart, sourceRangeStart, length) in map[key]!) {
        var overlapStart = max(start, sourceRangeStart);
        var overlapEnd = min(end, sourceRangeStart + length);

        if (overlapStart < overlapEnd) {
          // overlap
          newSeedRanges.add((overlapStart - sourceRangeStart + destinationRangeStart, overlapEnd - sourceRangeStart + destinationRangeStart));

          if (overlapStart > start) {
            // rest of range needs to be parsed as well.
            seedRanges.add((start, overlapStart));
          }
          if (end > overlapEnd) {
            // rest of range needs to be parsed as well.
            seedRanges.add((overlapEnd, end));
          }
          hasOverlap = true;
          break;
        }
      }
      if (!hasOverlap) {
        // no mapping found.
        newSeedRanges.add((start, end));
      }
    }
    seedRanges = newSeedRanges;
  });

  seedRanges.sort((rangeA, rangeB) => rangeA.$1 - rangeB.$1);
  print(seedRanges[0].$1);
}

int? getMinSource(
    List<int> seeds, Map<String, Map<(int, int), (int, int)>> map) {
  int? minSource = null;
  seeds.forEach((seed) {
    int source = getLocation(seed, map);
    if (minSource == null) {
      minSource = source;
    } else {
      minSource = min(minSource!, source);
    }
  });
  return minSource;
}

int getLocation(int seed, Map<String, Map<(int, int), (int, int)>> map) {
  var source = seed;
  map.keys.forEach((m) {
    for (var k in map[m]!.keys) {
      if (source >= k.$1 && source <= k.$2) {
        source = map[m]![k]!.$1 + (source - k.$1);
        break;
      }
    }
  });
  return source;
}

Map<String, List<(int, int, int)>> parse2(Iterable<String> lines) {
  Map<String, List<(int, int, int)>> m = new Map();
  String currentMapName = '';
  List<(int, int, int)> currentList = [];

  for (var i = 2; i < lines.length; i++) {
    var line = lines.elementAt(i);
    if (line.isEmpty) {
      m[currentMapName] = currentList;
      currentMapName = '';
      currentList = [];
    } else if (mapReg.hasMatch(line)) {
      var match = mapReg.firstMatch(line);
      currentMapName = '${match?.group(1)}-${match?.group(2)}';
    } else {
      var [destinationRangeStart, sourceRangeStart, rangeLength] =
          getNumbersFromString(line);
      currentList.add((destinationRangeStart, sourceRangeStart, rangeLength));
    }
  }
  //add last
  m[currentMapName] = currentList;
  return m;
}

Map<String, Map<(int, int), (int, int)>> parse(Iterable<String> lines) {
  Map<String, Map<(int, int), (int, int)>> mapOfMaps = new Map();
  String currentMapName = '';
  Map<(int, int), (int, int)> currentMap = new Map();

  for (var i = 2; i < lines.length; i++) {
    var line = lines.elementAt(i);
    if (line.isEmpty) {
      mapOfMaps[currentMapName] = currentMap;
      currentMapName = '';
      currentMap = new Map();
    } else if (mapReg.hasMatch(line)) {
      var match = mapReg.firstMatch(line);
      currentMapName = '${match?.group(1)}-${match?.group(2)}';
    } else {
      var [destinationRangeStart, sourceRangeStart, rangeLength] =
          getNumbersFromString(line);
      var key = (sourceRangeStart, sourceRangeStart + rangeLength - 1);
      currentMap[key] =
          (destinationRangeStart, destinationRangeStart + rangeLength - 1);
    }
  }
  //add last
  mapOfMaps[currentMapName] = currentMap;
  return mapOfMaps;
}


// void parseSeeds(String s, Map<String, Map<dynamic, dynamic>> map) {
//   var numbersFromString = getNumbersFromString(s);

//   int minRange = numbersFromString[0];
//   int maxRange = numbersFromString[0];
//   List<String> ranges = [];
//   for (var i = 0; i < numbersFromString.length; i += 2) {
//     minRange = min(minRange, numbersFromString[i]);
//     maxRange =
//         max(maxRange, numbersFromString[i] + numbersFromString[i + 1] - 1);
//     ranges.add(
//         '${numbersFromString[i]}-${numbersFromString[i] + numbersFromString[i + 1] - 1}');
//   }
//   int minSource = 1000000000000;

//   // this will take forever

//   // for (var i = minRange; i <= maxRange; i++) {
//   //   if(rangesContainNumber(ranges, i)){
//   //     var location = getLocation(i, map);
//   //     print('$i, $location');
//   //     minSource = min(minSource, location);
//   //   }
//   // }
//   print(minSource);
// }

bool rangesContainNumber(List<String> ranges, int nr) {
  return ranges.firstWhere((element) {
    var [min, max] = getNumbersFromString(element);
    return nr >= min && nr <= max;
  }, orElse: () => '').isNotEmpty;
}
