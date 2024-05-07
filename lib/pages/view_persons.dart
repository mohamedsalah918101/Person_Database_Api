import 'package:flutter/material.dart';

import '../model/person.dart';
import '../response/all_persons.dart';
import '../response/delete_person.dart';
import 'add_person.dart';
import 'edit_person.dart';

class ViewPersons extends StatefulWidget {
  @override
  _ViewPersonsState createState() => _ViewPersonsState();
}

class _ViewPersonsState extends State<ViewPersons> {
  late Future<List<Person>> futurePersons;

  @override
  void initState() {
    super.initState();
    futurePersons = fetchPersons();
  }

  Future<void> _refreshPersons() async {
    setState(() {
      futurePersons = fetchPersons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Persons'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 35,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPerson()),
              ).then((addedPerson) {
                if (addedPerson != null) {
                  setState(() {
                    // Add the added person to the list
                    futurePersons = fetchPersons();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPersons,
        child: FutureBuilder<List<Person>>(
          future: futurePersons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Person> persons = snapshot.data!;
              return ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Text(persons[index].name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Person ID: ${persons[index].personID}'),
                          Text('Nationality ID: ${persons[index].nationalityID}'),
                          Text('Age: ${persons[index].age.toStringAsFixed(1)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red,),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete this person?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deletePerson(persons[index].personID).then((success) {
                                          if (success) {
                                            setState(() {
                                              persons.removeAt(index);
                                            });
                                            Navigator.of(context).pop();
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Error'),
                                                content: Text('Failed to delete person.'),
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
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green,),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditPerson(person: persons[index])),
                              ).then((editedPerson) {
                                if (editedPerson != null) {
                                  setState(() {
                                    persons[index] = editedPerson;
                                  });
                                }
                              });
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
