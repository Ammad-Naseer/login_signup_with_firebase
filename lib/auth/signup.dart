import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _companyname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _availability = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isValidate = false;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        _showSnackBar('Successfully signed up!');
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _showSnackBar('The account already exists for that email.');
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {
              _isValidate = _formKey.currentState!.validate();
            });
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 233, 244, 242),
                            image: _selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.4), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    const Offset(0, 3), // Offset from the top
                              ),
                            ],
                          ),
                          child: _selectedImage == null
                              ? const Icon(
                                  CupertinoIcons.person,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        if (_selectedImage != null)
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Name is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.person,
                          size: 20, color: Colors.black54),
                      hintText: 'User Name',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Email is empty';
                      } else if (!_isValidEmail(text)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.mail,
                          size: 20, color: Colors.black54),
                      hintText: 'Email Address',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is empty';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one capital letter';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one small letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      }
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }

                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: Colors.black54),
                      ),
                      hintText: 'Password',
                      fillColor: const Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _companyname,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Company Name is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon:
                          Icon(Icons.business, size: 20, color: Colors.black54),
                      hintText: 'Company Name',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Phone is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.phone,
                          size: 20, color: Colors.black54),
                      hintText: 'Phone',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _address,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Address is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.location_on_outlined,
                          size: 20, color: Colors.black54),
                      hintText: 'Address',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _availability,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Availability is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.clock,
                          size: 20, color: Colors.black54),
                      hintText: 'Availability',
                      fillColor: Color.fromARGB(255, 233, 244, 242),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 232, 70), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _isValidate ? signUpWithEmailAndPassword : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
