
import 'dart:io';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';
import '../widgets/edit_img_picker.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel currentDriver;
  const EditUserScreen(this.currentDriver, {Key? key}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditDriverState();
}

class _EditDriverState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final UserModel updatedDriver = UserModel();


  late TextEditingController _emailController;
  late TextEditingController _userNameController;


  @override
  void initState() {
    super.initState();

    updatedDriver.email = widget.currentDriver.email;
    updatedDriver.userName = widget.currentDriver.userName;

    _emailController = TextEditingController(text: updatedDriver.email);
    _userNameController = TextEditingController(text: updatedDriver.userName);


  }

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _pickedImage(File? pickedImage) {
    updatedDriver.imageURL = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              fontSize: 36),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    EditPickImage(_pickedImage, widget.currentDriver.imageURL),
                    SizedBox(height: size.height * 0.04),
                    // Email TextField
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: true,
                        enableSuggestions: true,
                        key: const ValueKey('Email'),
                        validator: (email) {
                          if (email!.isEmpty) {
                            return "                        Please enter email address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "Email",
                        ),
                        onChanged: (email) =>
                        updatedDriver.email = email.toLowerCase(),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                              textAlign: TextAlign.center,
                              key: const ValueKey('User Name'),
                              keyboardType: TextInputType.name,
                              controller: _userNameController,
                              autocorrect: true,
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                              validator: (userName) {
                                if (userName!.isEmpty) {
                                  // starts with an uppercase letter (including accented letters)
                                  // followed by one or more lowercase letters, hyphens, commas, periods, spaces,
                                  // apostrophes, or single quotes. The name can end with zero or more spaces.
                                  return '     please enter valid name';
                                }
                                return null;
                              },
                              onChanged: (userName) {
                                updatedDriver.userName = userName;
                              },
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'User Name'),
                            ),
                          ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: SizedBox(
                        height: 45.0,
                        width: size.width * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              updateUser(
                                  updatedDriver, widget.currentDriver, context);
                            }
                        // Navigator.pushNamed(context, ProfileScreen.id, arguments: updatedDriver.UserID);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
        ),
            ),
          ),
      ),
    );
  }
}
