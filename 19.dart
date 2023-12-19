import 'dart:io';
import 'dart:math';

import 'utils.dart';

void main() {
  var lines = new File('input.txt').readAsLinesSync();

  Map<String, List<String>> workflows = Map();
  int startOfRatings = 0;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].isEmpty) {
      startOfRatings = i + 1;
      break;
    }
    var [key, rest] = lines[i].split('{');
    var rules = rest.substring(0, rest.length - 1).split(',');
    workflows.putIfAbsent(key, () => rules);
  }

  int pt1 = 0;
  for (var i = startOfRatings; i < lines.length; i++) {
    var rating = lines[i]
        .substring(1, lines[i].length - 1)
        .split(',')
        .map((e) => int.parse(e.split('=')[1]))
        .toList();
    var accepted = isAccepted(rating, workflows);
    if (accepted) {
      pt1 += rating.reduce((value, element) => value + element);
    }
  }
  print(pt1);

  var acceptableRatings =
      inferRating(workflows, 'in', [1, 4000, 1, 4000, 1, 4000, 1, 4000]);

  int pt2 = 0;
  acceptableRatings.forEach((r) {
    var sum = (r[1] - r[0] + 1) * (r[3] - r[2] + 1) * (r[5] - r[4] + 1) * (r[7] - r[6] + 1);
    print('$r : $sum');
    pt2 += sum;
  });
  print(pt2);
}

bool isAccepted(List<int> rating, Map workflows) {
  String w = 'in';
  while (w != 'A' && w != 'R') {
    w = processWorkflow(rating, workflows[w]);
  }
  return w == 'A';
}

final String XMAS = 'xmas';

String processWorkflow(List<int> rating, List<String> rules) {
  for (var rule in rules) {
    var numbersFromString = getNumbersFromString(rule);
    if (numbersFromString.length > 0) {
      var partRating = rating[XMAS.indexOf(rule[0])];
      int minMax = numbersFromString[0];

      if (rule[1] == '<' && partRating < minMax) {
        return rule.split(':')[1];
      } else if (rule[1] == '>' && partRating > minMax) {
        return rule.split(':')[1];
      }
    } else {
      return rule;
    }
  }
  throw new Exception('Cannot process $rules for rating $rating');
}

// inferred = [Xmin, Xmax, Mmin, Mmax, etc];

List<List<int>> inferRating(
    Map workflows, String currentWorkflow, List<int> inferred) {
  if (currentWorkflow == 'A') {
    return [inferred];
  } else if (currentWorkflow == 'R') {
    return List.empty();
  } else {
    var rules = workflows[currentWorkflow];
    List<List<int>> acceptedRatings = [];

    for (var rule in rules) {
      var numbersFromString = getNumbersFromString(rule);
      if (numbersFromString.length > 0) {
        var nr = numbersFromString[0];
        var nextWorkflow = rule.split(':')[1];
        var inferredIndexMin = XMAS.indexOf(rule[0]) * 2;
        List<int> copy = List.from(inferred);
        if (rule[1] == '>') {
          copy[inferredIndexMin] = nr + 1;
          acceptedRatings.addAll(inferRating(workflows, nextWorkflow, copy));
          // add the else statement to the inferred.
          inferred[inferredIndexMin + 1] = nr;
        } else {
          // <
          copy[inferredIndexMin + 1] = nr - 1;
          acceptedRatings.addAll(inferRating(workflows, nextWorkflow, copy));
          // add the else statement to the inferred.
          inferred[inferredIndexMin] = nr;
        }
      } else {
        acceptedRatings.addAll(inferRating(workflows, rule, inferred));
      }
    }
    return acceptedRatings;
  }
}
