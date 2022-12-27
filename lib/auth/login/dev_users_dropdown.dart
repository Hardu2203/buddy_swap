import 'package:buddy_swap/user/dev_users.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';

class DevUsersDropdown extends StatefulWidget {
  DevUsersDropdown(this.selectUser, {Key? key}) : super(key: key);

  Function(UserModel selectedUser) selectUser;

  @override
  State<DevUsersDropdown> createState() => _DevUsersDropdownState();
}

class _DevUsersDropdownState extends State<DevUsersDropdown> {
  final Set<UserModel> _devUsers = DevUsers().devUsers;

  late UserModel _dropdownValue;

  void dropdownCallback(UserModel? user) {
      widget.selectUser(user!);
      setState(() {
        _dropdownValue = user;
      });
  }


  @override
  void initState() {
    super.initState();
    _dropdownValue = _devUsers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<UserModel>(
        items:
        _devUsers.map<DropdownMenuItem<UserModel>>((UserModel user) {
          return DropdownMenuItem<UserModel>(
              value: user,
              child: Text(user.name));
        }).toList(),
        value: _dropdownValue,
        onChanged: dropdownCallback,

      ),
    );
  }
}


