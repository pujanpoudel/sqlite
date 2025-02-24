import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sqlite/models/user_model.dart';
import '../services/connectivity_service.dart';
import '../services/database_service.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]) {}

  // final DatabaseService _databaseService = DatabaseService.instance;
  // final ConnectivityService _connectivityService = ConnectivityService();

  // Future<void> addToLocalDatabase(List<User> users) async {
  //   await Future.wait(users.map((item) => _databaseService.addUserFromRemote(
  //       item.name, item.age, item.gender, item.email)));
  // }

  // Future<List<User>> fetchLocally() async {
  //   return await _databaseService.getUser();
  // }

  // Future<void> _initialize() async {
  //   bool isConnected = await _connectivityService.isConnected();

  //   if (isConnected) {
  //     var users = await ApiClient.getUsers();
  //     await addToLocalDatabase(users);
  //     state = users;
  //   } else {
  //     var localUsers = await fetchLocally();
  //     state = localUsers;
  //   }
  // }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;
  var hasInternet = false;
  @override
  void initState() {
    super.initState();
  }

  checkInternet() async {
    final ConnectivityService _connectivityService = ConnectivityService();
    bool isConnected = await _connectivityService.isConnected();
    hasInternet = isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final usersAsyncValue = ref.watch(userNotifierProvider);
    final users = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users'),
        // Container(
        //   padding: const EdgeInsets.all(10),
        //   color: Colors.red,
        //   child: const Text(
        //     "Internet Not Available",
        //     style: TextStyle(color: Colors.white, fontSize: 18),
        //   ),
        // ),
      ),
      body: usersAsyncValue.when(
        data: (users) {
          // addToLocalDatabase(users);
          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blue,
            strokeWidth: 4.0,
            onRefresh: () async {
              ref.invalidate(users);
              return Future<void>.delayed(const Duration(seconds: 2));
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
                        builder: (_) => _editUserDialog(user));
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    tileColor: Colors.purple.shade50,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _databaseService.deleteUser(user.id);
                        ref.invalidate(users);
                      },
                    ),
                    title: Text(
                      "${user.id}. ${user.name} ${user.age}y/o ${user.gender}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text("mail: ${user.email}"),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("error: $error")),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (_) => _addUserDialog());
        },
      ),
    );
  }

  Widget _editUserDialog(User user) {
    _nameController.text = user.name;
    _ageController.text = user.age.toString();
    _genderController.text = user.gender;
    _mailController.text = user.email;

    return AlertDialog(
      title: const Text('Update User'),
      content: _userForm(),
      actions: [
        MaterialButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.purple.shade50,
          onPressed: () async {
            await _databaseService.updateUser(
              user.id.toString(),
              _nameController.text,
              _ageController.text,
              _genderController.text,
              _mailController.text,
            );
            ref.invalidate(users);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  Widget _addUserDialog() {
    _nameController.clear();
    _ageController.clear();
    _genderController.clear();
    _mailController.clear();

    return AlertDialog(
      title: const Text('Add User'),
      content: _userForm(),
      actions: [
        MaterialButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.purple.shade50,
          onPressed: () async {
            await _databaseService.addUser(
              _nameController.text,
              _ageController.text,
              _genderController.text,
              _mailController.text,
            );
            ref.invalidate(users);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _userForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Name"),
        ),
        const SizedBox(height: 5),
        TextField(
          keyboardType: TextInputType.number,
          controller: _ageController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Age"),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _genderController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Gender (Male/Female)"),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _mailController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Mail"),
        ),
      ],
    );
  }
}
