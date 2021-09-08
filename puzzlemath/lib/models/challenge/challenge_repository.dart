import 'package:puzzlemath/config/database.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeRepository {
  static const TABLE_NAME = 'challenges';

  late final Database connection;

  ChallengeRepository(this.connection);

  static connected() async {
    // TODO: somehow inject the database connection
    final connection = await connectToDatabase();
    return ChallengeRepository(connection);
  }

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
        "Small numbers are boring. Kids know that they can create gigantic numbers by chaining multiple numbers.",
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
];
