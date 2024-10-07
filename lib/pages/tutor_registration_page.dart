import 'package:flutter/material.dart';

class TutorRegistrationPage extends StatefulWidget {
  @override
  _TutorRegistrationPageState createState() => _TutorRegistrationPageState();
}

class _TutorRegistrationPageState extends State<TutorRegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tutor Registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Register as a Tutor",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildTextField(nameController, 'Enter Name'),
                SizedBox(height: 10),
                _buildTextField(emailController, 'Enter Email Address'),
                SizedBox(height: 10),
                _buildTextField(ageController, 'Enter Age'),
                SizedBox(height: 10),
                _buildTextField(locationController, 'Enter Location'),
                SizedBox(height: 10),
                _buildTextField(qualificationController, 'Enter Qualification'),
                SizedBox(height: 10),
                _buildPasswordField(passwordController, 'Enter Password'),
                SizedBox(height: 10),
                _buildDateField(context),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Handle tutor registration logic
                    _handleRegistration();
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue),
            ),
            hintText: selectedDate != null
                ? "${selectedDate!.toLocal()}".split(' ')[0]
                : 'Select Date',
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleRegistration() {
    // Handle registration logic here
    // Access the values using the controllers
    String name = nameController.text;
    String email = emailController.text;
    String age = ageController.text;
    String location = locationController.text;
    String qualification = qualificationController.text;
    String password = passwordController.text;

    // Display or store the information as needed
    print("Registered: $name, $email, $age, $location, $qualification, $password, $selectedDate");
  }
}
