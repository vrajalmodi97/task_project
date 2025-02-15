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
  
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsers(SharedPrefs().userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Recipient")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                UserData user = state.users[index];
                return ListTile(
                  title: Text(user.name ?? "No Name"),
                  subtitle: Text(user.email ?? "No Email"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendMoneyScreen(recipient: user),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text("Failed to load users"));
          }
        },
      ),
    );
  }
}
