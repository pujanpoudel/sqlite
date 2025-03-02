import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite/features/users/data/model/user_model.dart';
import 'package:sqlite/features/users/user_notifier.dart';
import 'package:sqlite/services/connectivity_service.dart';
import 'package:sqlite/services/database_service.dart';

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
  var isOnline = true;
  @override
  void initState() {
    super.initState();
  }

  checkInternet() async {
    final ConnectivityService connectivityService = ConnectivityService();
    bool isConnected = await connectivityService.isConnected();
    isOnline = isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userNotifier.refreshUsers(),
          ),
        ],
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userState.error != null
              ? RefreshIndicator(
                  onRefresh: () => userNotifier.refreshUsers(),
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  strokeWidth: 4.0,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: userState.users.length,
                    itemBuilder: (context, index) {
                      User user = userState.users[index];
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
                              ref.invalidate(userNotifierProvider);
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
                )
              : Center(
                  child: Text(userState.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 18))),
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
            ref.invalidate(userNotifierProvider);
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
            ref.invalidate(userNotifierProvider);
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
