import 'package:http/http.dart' as http;

Future<bool> deletePerson(int personID) async {
  final response = await http.get(Uri.parse('http://mohagado-001-site1.itempurl.com/Person/deletePerson?personID=$personID'));

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to delete person');
  }
}
