import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/person.dart';

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _ageController;
  late TextEditingController _nationalityIDController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthDateController = TextEditingController();
    _ageController = TextEditingController();
    _nationalityIDController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Person'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Birth Date'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _birthDateController.text = date.toString().split(' ')[0];
                    });
                  }
                },
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _nationalityIDController,
                decoration: InputDecoration(labelText: 'Nationality ID'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate input and call addPerson function
                  if (
                      _nameController.text.isNotEmpty &&
                      _birthDateController.text.isNotEmpty &&
                      _ageController.text.isNotEmpty &&
                      _nationalityIDController.text.isNotEmpty) {
                    addPerson();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill in all fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Add Person'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addPerson() async {
    try {
      // Create a Person object from the input fields
      Person newPerson = Person(
        personID: 0,
        name: _nameController.text,
        birthDate: DateTime.parse(_birthDateController.text),
        age: double.parse(_ageController.text),
        nationalityID: int.parse(_nationalityIDController.text),
      );

      // Send the newPerson data to the API
      final response = await http.post(
        Uri.parse('http://mohagado-001-site1.itempurl.com/Person/addPerson'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newPerson.toJson()),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = jsonDecode(response.body);

        // Create a new Person object from the response
        Person addedPerson = Person.fromJson(responseBody);

        Navigator.of(context)
            .pop(addedPerson); // Return the added person to the previous screen
      } else {
        // If the request was not successful, show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add person.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // If an error occurs, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add person: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _ageController.dispose();
    _nationalityIDController.dispose();
    super.dispose();
  }
}
