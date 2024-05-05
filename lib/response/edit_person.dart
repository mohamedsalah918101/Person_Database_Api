import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/person.dart';

Future<bool> editPerson(Person person) async {
  final response = await http.post(
    Uri.parse('http://mohagado-001-site1.itempurl.com/Person/editPerson'),
    body: json.encode(person.toJson()),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to edit person');
  }
}
