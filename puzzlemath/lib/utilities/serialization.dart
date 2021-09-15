import 'dart:convert';

T stringToEnum<T>(String input, List<T> enumValues) {
  return enumValues.firstWhere((e) => e.toString() == input);
}

String enumToString<T>(T input) {
  return input.toString();
}

List<T> jsonDecodeEnumList<T>(String input, List<T> enumValues) {
  List<dynamic> items = jsonDecode(input);
  return items.map((item) => stringToEnum(item, enumValues)).toList();
}

String jsonEncodeEnumList<T>(List<T> input) {
  return jsonEncode(input.map(enumToString).toList());
}
