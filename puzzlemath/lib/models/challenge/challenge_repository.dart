import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeRepository {
  static const TABLE_NAME = 'challenges';

  late final Database connection;

  ChallengeRepository(this.connection);

  Future<Challenge> save(Challenge challenge) async {
    final id = await connection.insert(
      TABLE_NAME,
      challenge.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Challenge(id,
        name: challenge.name,
        description: challenge.description,
        solution: challenge.solution,
        availableMarkers: challenge.availableMarkers,
        state: challenge.state);
  }

  Future<List<Challenge>> saveAll(List<Challenge> challenges) async {
    return Future.wait(challenges.map((challenge) => save(challenge)));
  }

  Future<List<Challenge>> load() async {
    final List<Map<String, dynamic>> items =
        await connection.query(TABLE_NAME, orderBy: 'id ASC');
    final storedChallenges =
        items.map((item) => Challenge.fromMap(item)).toList();
    final challengeStates = Map.fromIterable(storedChallenges,
        key: (challenge) => challenge.id,
        value: (challenge) => challenge.state);
    return CHALLENGES.map((challenge) {
      return challenge
          .copyWithState(challengeStates[challenge.id] ?? challenge.state);
    }).toList();
  }
}

const List<Challenge> CHALLENGES = [
  Challenge(0,
      name: "What's the magic number?",
      description:
          "Learn how to use a single number. Simply take a picture of it and let the magic unfold.",
      solution: 7,
      availableMarkers: [Marker.Digit7],
      state: ChallengeState.Unlocked),
  Challenge(
    1,
    name: "Child's play.",
    description:
        "Small numbers are boring. Kids know that they can create gigantic numbers by chaining multiple puzzle pieces.",
    solution: 137,
    availableMarkers: [
      Marker.Digit1,
      Marker.Digit3,
      Marker.Digit7,
    ],
  ),
  Challenge(2,
      name: 'Easy peasy, lemon squeezy!',
      description:
          "Have you heard of addition? Put a '+' inbetween two numbers and see what happens!",
      solution: 34,
      availableMarkers: [
        Marker.Digit2,
        Marker.Digit0,
        Marker.OperatorAdd,
        Marker.Digit1,
        Marker.Digit4,
      ]),
  Challenge(3,
      name: "Schnapszahl!",
      description: "Turn it around however you like. It's not gonna change.",
      solution: 999,
      availableMarkers: [
        Marker.Digit1,
        Marker.Digit2,
        Marker.Digit3,
        Marker.Digit6,
        Marker.Digit7,
        Marker.Digit8,
        Marker.OperatorAdd,
      ]),
  Challenge(4,
      name: "Take a step back.",
      description: "Is the number too large? Try the '-' sign.",
      solution: 99,
      availableMarkers: [
        Marker.Digit1,
        Marker.Digit0,
        Marker.Digit0,
        Marker.OperatorSubtract,
        Marker.Digit1
      ]),
  Challenge(5,
      name: "Bring it on!",
      description: "Use everything that you've learned so far to solve this.",
      solution: 51,
      availableMarkers: [
        Marker.Digit7,
        Marker.OperatorAdd,
        Marker.Digit4,
        Marker.Digit9,
        Marker.OperatorSubtract,
        Marker.Digit5
      ]),
  Challenge(6,
      name: "Practice makes perfect.",
      description:
          "Let's try another one. Did you notice that there's more than a single solution?",
      solution: 30,
      availableMarkers: [
        Marker.Digit3,
        Marker.Digit0,
        Marker.OperatorSubtract,
        Marker.Digit8,
        Marker.OperatorAdd,
        Marker.Digit2,
        Marker.OperatorAdd,
        Marker.Digit6
      ]),
  Challenge(7,
      name: "Try something new!",
      description:
          "If Tom and Jerry both have three apples...how many apples are there?",
      solution: 9,
      availableMarkers: [
        Marker.Digit3,
        Marker.OperatorMultiply,
        Marker.Digit3
      ]),
  Challenge(8,
      name: "More apples!",
      description:
          "I can't get enough. Again, there's more than one way to victory.",
      solution: 126,
      availableMarkers: [
        Marker.Digit9,
        Marker.OperatorMultiply,
        Marker.Digit7,
        Marker.Digit2
      ]),
  Challenge(9,
      name: "Turn the power off!",
      description: "Make things disappear, wizard!",
      solution: 0,
      availableMarkers: [
        Marker.Digit9,
        Marker.Digit9,
        Marker.OperatorMultiply,
        Marker.Digit0
      ]),
  Challenge(10,
      name: "An optical illusion",
      description: "Sometimes, thing's are not as they seem.",
      solution: 7,
      availableMarkers: [
        Marker.Digit7,
        Marker.OperatorMultiply,
        Marker.Digit1,
        Marker.OperatorAdd,
        Marker.Digit0
      ]),
];
