import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/apiClient/api_client.dart';
import 'package:sqlite/models/user_model.dart';

import '../services/connectivity_service.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  final ApiClient _apiClient = ApiClient();
  // List<User> remoteUsers = [];

  List<User> users = [];
  final DatabaseService _databaseService = DatabaseService.instance;

  bool _isLoading = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataLocal();
    fetchUserRemote();
    _connectivityService.connectionStream.listen((status) {
      setState(() {
        _isConnected = status;
      });
    });
  }

  fetchUserRemote() async {
    users = await _apiClient.getUsers();
    addToLocalDatabase(users);
    print('got from remote and added to local database');
    setState(() {
      _isLoading = false;
    });
  }

  fetchDataLocal() async {
    try {
      users = await _databaseService.getUser();
      print('fetched from local storage');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addToLocalDatabase(List<User> users) async {
    for (var item in users) {
      await _databaseService.addUserFromRemote(
          item.name, item.age, item.gender, item.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          // leading: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          title: _isConnected
              ? Text("Users")
              : Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.red,
                  child: Text(
                    "Internet Not Available",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )

          //  const Text('Users'),
          ),
      body: _isLoading
          ? RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.blue,
              strokeWidth: 4.0,
              onRefresh: () async {
                setState(() {});
                return Future<void>.delayed(const Duration(seconds: 3));
              },
              child: Center(child: Text("loading")))
          : RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.blue,
              strokeWidth: 4.0,
              onRefresh: () async {
                setState(() {});
                return Future<void>.delayed(const Duration(seconds: 3));
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Update User'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                            // contentPadding: EdgeInsets.all(20),
                                            border: OutlineInputBorder(),
                                            hintText: "Name"),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                          keyboardType: TextInputType.number,
                                          controller: _ageController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Age")),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                          controller: _genderController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  "Gender(Male or Female)")),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                          controller: _mailController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Mail")),
                                      MaterialButton(
                                        child: const Text('Update'),
                                        textTheme: ButtonTextTheme.accent,
                                        color: Colors.purple.shade50,
                                        onPressed: () async {
                                          // var users = await _databaseService.getUser();
                                          try {
                                            // if (_id == null ||
                                            //     _name == null ||
                                            //     _age == null ||
                                            //     _gender == null ||
                                            //     _mail == null) {
                                            //   print("Please fill all fields");
                                            //   return;
                                            // }

                                            await _databaseService.updateUser(
                                                user.id.toString(),
                                                _nameController.text,
                                                _ageController.text,
                                                _genderController.text,
                                                _mailController.text);
                                            fetchDataLocal();
                                            setState(
                                                () {}); // Update UI if necessary
                                            Navigator.pop(context);
                                          } catch (e) {
                                            print("Error adding user: $e");
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ));
                      },
                      child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          tileColor: Colors.purple.shade50,
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _databaseService.deleteUser(user.id);
                              users.removeWhere((i) => i.id == user.id);
                              setState(() {});
                            },
                          ),
                          title: Text(
                            "${user.id}. ${user.name} ${user.age}y/o ${user.gender}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "mail: ${user.email}",
                              ),
                            ],
                          )),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Text('Add User'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                // contentPadding: EdgeInsets.all(20),
                                border: OutlineInputBorder(),
                                hintText: "Name"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                              keyboardType: TextInputType.number,
                              controller: _ageController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Age")),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                              controller: _genderController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Gender(Male or Female)")),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                              controller: _mailController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Mail")),
                          MaterialButton(
                            child: const Text('Add'),
                            textTheme: ButtonTextTheme.accent,
                            color: Colors.purple.shade50,
                            onPressed: () async {
                              // var users = await _databaseService.getUser();
                              try {
                                // if (_name == null ||
                                //     _age == null ||
                                //     _gender == null ||
                                //     _mail == null) {
                                //   print("Please fill all fields");
                                //   return;
                                // }

                                await _databaseService.addUser(
                                    _nameController.text,
                                    _ageController.text,
                                    _genderController.text,
                                    _mailController.text);
                                fetchDataLocal();
                                setState(() {}); // Update UI if necessary
                                Navigator.pop(context);
                              } catch (e) {
                                print("Error adding user: $e");
                              }
                            },
                          )
                        ],
                      ),
                    ));
          }),
    );
  }
}
