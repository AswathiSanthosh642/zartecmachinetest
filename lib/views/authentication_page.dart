import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:zartechmachinetest/views/home.dart';

import '../controllers/auth_controller.dart';


class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Firebase Logo
              Image.network(
                'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_256dp.png',
                height: 180,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_fire_department, size: 100, color: Colors.orange),
              ),
              const Spacer(flex: 3),
              // Google Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading ? null : () async {
                    GoogleSignInAccount? user = await authController.signInWithGoogle();
                    if (user != null && context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                            (route) => false,
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Google Sign-In failed")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.g_mobiledata, color: Color(0xFF4285F4), size: 24),
                        ),
                      ),
                      const Text(
                        "Google",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      if (authController.isLoading)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading ? null : () => _showPhoneDialog(context, authController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5AB45A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.phone, color: Colors.white, size: 24),
                      ),
                      Text(
                        "Phone",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhoneDialog(BuildContext context, AuthController authController) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login with Phone"),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: "+91 1234567890",
            labelText: "Phone Number",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (phoneController.text.isEmpty) return;
              authController.signInWithPhone(
                phoneController.text,
                    (verificationId) {
                  Navigator.pop(context);
                  _showOTPDialog(context, authController, verificationId);
                },
                    (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                },
              );
            },
            child: const Text("Verify"),
          )
        ],
      ),
    );
  }

  void _showOTPDialog(BuildContext context, AuthController authController, String verificationId) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter OTP"),
        content: TextField(
          controller: otpController,
          decoration: const InputDecoration(
            hintText: "6-digit code",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (otpController.text.length < 6) return;
              await authController.verifyOTP(verificationId, otpController.text);
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false,
                );
              }
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
