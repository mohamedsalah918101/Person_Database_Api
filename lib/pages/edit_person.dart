import 'package:flutter/material.dart';

import '../model/person.dart';
import '../response/edit_person.dart';

class EditPerson extends StatefulWidget {
  final Person person;

  EditPerson({required this.person});

  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  late TextEditingController _personIDController;
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _ageController;
  late TextEditingController _nationalityIDController;

  @override
  void initState() {
    super.initState();
    _personIDController = TextEditingController(text: widget.person.personID.toString());
    _nameController = TextEditingController(text: widget.person.name);
    _birthDateController = TextEditingController(text: widget.person.birthDate.toString());
    _ageController = TextEditingController(text: widget.person.age.toString());
    _nationalityIDController = TextEditingController(text: widget.person.nationalityID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Person'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _personIDController,
              decoration: InputDecoration(labelText: 'Person ID'),
              keyboardType: TextInputType.number,
            ),
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
            SizedBox(height: 30,),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                // Save changes and call editPerson function
                Person editedPerson = Person(
                  personID: int.parse(_personIDController.text),
                  name: _nameController.text,
                  birthDate: DateTime.parse(_birthDateController.text),
                  age: double.parse(_ageController.text),
                  nationalityID: int.parse(_nationalityIDController.text),
                );
                editPerson(editedPerson).then((success) {
                  if (success) {
                    Navigator.of(context).pop(editedPerson);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to edit person.'),
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
                });
              },
              child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _personIDController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _ageController.dispose();
    _nationalityIDController.dispose();
    super.dispose();
  }
}
