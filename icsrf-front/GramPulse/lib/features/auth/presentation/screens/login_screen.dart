import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  final String? selectedRole;
  
  const LoginScreen({super.key, this.selectedRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _requestOtp() {
    if (_formKey.currentState!.validate()) {
      // Store the selected role and phone number for later use
      final phoneNumber = _phoneController.text;
      context.go('/otp-verification/$phoneNumber?role=${widget.selectedRole ?? 'citizen'}');
    }
  }

  String _getRoleDisplayName() {
    switch (widget.selectedRole) {
      case 'volunteer':
        return 'Volunteer';
      case 'officer':
        return 'Government Officer';
      case 'citizen':
      default:
        return 'Citizen';
    }
  }

  Color _getRoleColor() {
    switch (widget.selectedRole) {
      case 'volunteer':
        return Colors.green;
      case 'officer':
        return Colors.orange;
      case 'citizen':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
        backgroundColor: _getRoleColor(),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Role indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getRoleColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getRoleColor()),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.selectedRole == 'volunteer' 
                          ? Icons.volunteer_activism
                          : widget.selectedRole == 'officer'
                              ? Icons.account_balance
                              : Icons.person,
                      color: _getRoleColor(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logging in as ${_getRoleDisplayName()}',
                      style: TextStyle(
                        color: _getRoleColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Enter your phone number to continue',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your 10-digit phone number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _requestOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getRoleColor(),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Send OTP'),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  context.go('/role-selection');
                },
                child: const Text('Change Role'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
