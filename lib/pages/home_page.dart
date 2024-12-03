// ignore_for_file: prefer_const_constructors

import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

import '../components/user_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // get Chat and Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text('Home'),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // check for error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading ..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading . . .');
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display a list of users except for the current logged in user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // tapped on a user -> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverID: userData['uid'],
                recieverEmail: userData['email'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}