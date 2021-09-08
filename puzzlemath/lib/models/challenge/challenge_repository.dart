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
      solution: 137,
      availableMarkers: [Marker.Digit1, Marker.Digit3, Marker.Digit7],
      state: ChallengeState.Unlocked),
  Challenge(
    1,
    name: "Child's play.",
    solution: 2,
    availableMarkers: [
      Marker.Digit1,
      Marker.Digit1,
      Marker.OperatorAdd,
    ],
  ),
  Challenge(2,
      name: 'Easy peasy, lemon squeezy!',
      solution: 28,
      availableMarkers: [
        Marker.Digit2,
        Marker.Digit0,
        Marker.OperatorAdd,
        Marker.Digit1,
        Marker.Digit2,
        Marker.OperatorSubtract,
        Marker.Digit4
      ]),
  Challenge(3,
      name: "Let's turn these numbers up!",
      solution: 999,
      availableMarkers: [
        Marker.Digit3,
        Marker.Digit3,
        Marker.Digit3,
        Marker.Digit3,
        Marker.OperatorMultiply,
      ]),
];
