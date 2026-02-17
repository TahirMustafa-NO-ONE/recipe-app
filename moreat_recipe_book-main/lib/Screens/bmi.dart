import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  String? gender;
  double height = 157.0;
  double weight = 50.0;
  int age = 25;

  void calculateBMI() {
    double bmi = weight / ((height / 100) * (height / 100));
    String bmiCategory;
    String suggestion;
    String idealBMI = '18.5 - 24.9';

    // Adjust BMI based on age
    if (age < 18) {
      bmi *= 0.9;
    } else if (age > 60) {
      bmi *= 1.1;
    }

    // Determine BMI category
    if (bmi < 18.5) {
      bmiCategory = 'Underweight';
      suggestion = 'Consider eating more nutritious food.';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      bmiCategory = 'Normal';
      suggestion = 'Great! Maintain a balanced diet and exercise.';
    } else if (bmi >= 25 && bmi <= 29.9) {
      bmiCategory = 'Overweight';
      suggestion = 'Try regular exercise and healthy eating.';
    } else {
      bmiCategory = 'Obese';
      suggestion = 'Seek advice from a healthcare provider.';
    }

    // Show BMI result
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color.fromARGB(255, 255, 230, 240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your BMI',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 64, 129),
                ),
              ),
              SizedBox(height: 16),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your BMI is  ',
                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, color: Colors.black87),
                    ),
                    Text(
                      '${bmi.toStringAsFixed(1)}',
                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 64, 129)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Category: $bmiCategory',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 8),
              Text(
                suggestion,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Text(
                'Ideal BMI Range: $idealBMI',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 64, 129),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // You can use any icon you want
            color: Colors.white, // Set the color of the arrow icon
          ),
          onPressed: () {
            Navigator.pop(context); // Custom back action
          },
        ),
        backgroundColor: Color.fromARGB(255, 255, 64, 129),
        title: Text('Check your BMI', style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderCard(
                    icon: Icons.female,
                    label: 'Female',
                    isSelected: gender == 'Female',
                    onTap: () {
                      setState(() {
                        gender = 'Female';
                      });
                    },
                  ),
                  GenderCard(
                    icon: Icons.male,
                    label: 'Male',
                    isSelected: gender == 'Male',
                    onTap: () {
                      setState(() {
                        gender = 'Male';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildInputSection('Age', age.toDouble(), 10, 100, (value) {
                setState(() {
                  age = value.toInt();
                });
              }),
              buildInputSection('Height', height, 100, 220, (value) {
                setState(() {
                  height = value;
                });
              }),
              buildInputSection('Weight', weight, 30, 150, (value) {
                setState(() {
                  weight = value;
                });
              }),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 64, 129),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: calculateBMI,
                child: Text(
                  'Calculate your BMI!',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputSection(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Color.fromARGB(255, 255, 64, 129),
            inactiveTrackColor: Color.fromARGB(100, 255, 64, 129),
            thumbColor: Color.fromARGB(255, 255, 64, 129),
            overlayColor: Color.fromARGB(50, 255, 64, 129),
            valueIndicatorColor: Color.fromARGB(255, 255, 64, 129),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)} ${label == "Height" ? "cm" : label == "Weight" ? "kg" : "years"}',
          style: TextStyle(fontSize: 18),
        ),
        Container(
          width: 80,
          height: 2,
          color: Color.fromARGB(255, 255, 64, 129), // Underline color
        ),
        Divider(
          color: Colors.grey[400],
          thickness: 1,
          height: 30,
        ),
      ],
    );
  }
}

class GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 255, 230, 240) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 255, 64, 129) : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 90,
              color: isSelected ? Color.fromARGB(255, 255, 64, 129) : Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color.fromARGB(255, 255, 64, 129) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
