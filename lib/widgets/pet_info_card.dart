import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetInfoCard extends StatelessWidget {
  final Pet pet;

  PetInfoCard({required this.pet});

  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(0, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/candy.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(child: Text('Error Loading Image')));
                },
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Pet's name: ",
                        style: TextStyle(
                          fontSize:
                              14, // Set the font size for "Pet's name" here
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: '${pet.name}',
                        style: TextStyle(
                          fontSize:
                              18, // Set the font size for the pet's actual name here
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${pet.sex}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Age: ",
                        style: TextStyle(
                          fontSize:
                              14, // Set the font size for "Pet's name" here
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: '${pet.age}',
                        style: TextStyle(
                          fontSize:
                              18, // Set the font size for the pet's actual name here
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Type: ",
                        style: TextStyle(
                          fontSize:
                              14, // Set the font size for "Pet's name" here
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: '${pet.type}',
                        style: TextStyle(
                          fontSize:
                              18, // Set the font size for the pet's actual name here
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Weight: ",
                        style: TextStyle(
                          fontSize:
                              14, // Set the font size for "Pet's name" here
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: '${pet.weight} kg',
                        style: TextStyle(
                          fontSize:
                              18, // Set the font size for the pet's actual name here
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
