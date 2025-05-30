// import 'package:flutter/material.dart';
// import 'package:frontend/pages/auth/signin.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   String selectedRole = 'Please Select';
//   final List<String> roles = ['Please Select', 'User', 'Planter'];

//   String? selectedProvince;
//   final List<String> provinces = [
//     'กรุงเทพฯ',
//     'ชลบุรี',
//     'เชียงใหม่',
//     'นครราชสีมา',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 80),
//               const Text(
//                 'PLOOKE',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2,
//                 ),
//               ),
//               const SizedBox(height: 60),
//               const Text(
//                 'EMAIL',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'PASSWORD',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'CONFIRM PASSWORD',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'SELECT ROLE',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: selectedRole,
//                     isExpanded: true,
//                     items:
//                         roles.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Row(
//                               children: [
//                                 if (value == 'User') const Icon(Icons.person),
//                                 if (value == 'Planter')
//                                   const Icon(Icons.verified_user),
//                                 if (value == 'Please Select')
//                                   const SizedBox.shrink(),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   value,
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedRole = newValue!;
//                       });
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               if (selectedRole == 'Planter') ...[
//                 const Text(
//                   'SELECT PROVINCE',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white,
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedProvince,
//                       isExpanded: true,
//                       hint: const Text('Please select province'),
//                       items:
//                           provinces.map((String province) {
//                             return DropdownMenuItem<String>(
//                               value: province,
//                               child: Text(
//                                 province,
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             );
//                           }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedProvince = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'QR CODE',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 8),
//                 GestureDetector(
//                   onTap: () {
//                     // Handle QR code upload
//                   },
//                   child: Container(
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade400),
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.cloud_upload_outlined,
//                         size: 28,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 60,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     // Handle registration logic
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Colors.black, width: 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: const Text(
//                     'Register',
//                     style: TextStyle(fontSize: 20, color: Colors.black),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Already have an account? ',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignInPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'LOGIN',
//                         style: TextStyle(
//                           fontSize: 14,
//                           decoration: TextDecoration.underline,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/signin.dart';
import 'package:frontend/pages/planter/orderpage.dart';
import 'package:frontend/pages/user/homepage.dart';
import 'package:frontend/services/api.dart'; // Import the API service

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedRole = 'Please Select';
  final List<String> roles = ['Please Select', 'User', 'Planter'];

  String? selectedProvince;
  final List<String> provinces = [
    'กรุงเทพฯ',
    'ชลบุรี',
    'เชียงใหม่',
    'นครราชสีมา',
  ];

  bool _isLoading = false;

  Future<void> _register() async {
    // Validate inputs
    if (selectedRole == 'Please Select') {
      _showErrorDialog('Please select a role');
      return;
    }

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    if (selectedRole == 'Planter' && selectedProvince == null) {
      _showErrorDialog('Please select a province for planter role');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare registration data
      final registrationData = {
        'email': emailController.text,
        'password': passwordController.text,
        'role': selectedRole.toLowerCase(), // Convert to lowercase for backend
        if (selectedRole == 'Planter') 'province': selectedProvince,
        // 'qrcode': 'base64-encoded-qr-code' // You'll need to implement QR code upload
      };

      // Call API
      final response = await register(registrationData);

      // Handle successful registration
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );

        // Navigate based on role
        if (selectedRole == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      const HomePage(), // Replace with your actual HomePage
            ),
          );
        } else if (selectedRole == 'Planter') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      const OrderPage(), // Replace with your actual OrderPage
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Registration failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              const Text(
                'PLOOKE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'EMAIL',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text(
                'PASSWORD',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'CONFIRM PASSWORD',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'SELECT ROLE',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    items:
                        roles.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                if (value == 'User') const Icon(Icons.person),
                                if (value == 'Planter')
                                  const Icon(Icons.verified_user),
                                if (value == 'Please Select')
                                  const SizedBox.shrink(),
                                const SizedBox(width: 8),
                                Text(
                                  value,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedRole == 'Planter') ...[
                const Text(
                  'SELECT PROVINCE',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedProvince,
                      isExpanded: true,
                      hint: const Text('Please select province'),
                      items:
                          provinces.map((String province) {
                            return DropdownMenuItem<String>(
                              value: province,
                              child: Text(
                                province,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedProvince = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'QR CODE',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement QR code upload
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 28,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : OutlinedButton(
                          onPressed: _register,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 14),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
