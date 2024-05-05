import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/person.dart';

Future<List<Person>> fetchPersons() async {
  final response = await http.get(Uri.parse('http://mohagado-001-site1.itempurl.com/Person/getAllPersons'));

  if (response.statusCode == 200) {
    Iterable data = json.decode(response.body);
    return List<Person>.from(data.map((model) => Person.fromJson(model)));
  } else {
    throw Exception('Failed to load persons');
  }
}
