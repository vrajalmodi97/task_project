import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/user/user_bloc.dart';
import 'package:task_project/core/blocs/user/user_event.dart';
import 'package:task_project/core/blocs/user/user_state.dart';
import 'package:task_project/core/models/user.dart';
import 'package:task_project/screens/SendMoneyScreen.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserData> _allUsers = []; // Store all users
  List<UserData> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsers(SharedPrefs().userId));
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _allUsers
          .where((user) =>
              user.name!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              user.email!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Recipient",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button action
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search user...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) =>
                    _filterUsers(), // Correctly filtering users
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UserLoaded) {
                    _allUsers = state.users; // Store full user list
                    _filteredUsers =
                        _filteredUsers.isEmpty && _searchController.text.isEmpty
                            ? _allUsers
                            : _filteredUsers;

                    return ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        UserData user = _filteredUsers[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                user.name!.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(user.name ?? "No Name",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(user.email ?? "No Email"),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 18, color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SendMoneyScreen(recipient: user),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Failed to load users"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
