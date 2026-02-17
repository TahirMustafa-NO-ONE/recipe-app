import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomDialogBox {
  static void showAddToListDialog(
      BuildContext context,
      dynamic currentUser,
      Map<String, dynamic> recipeDetails,
      ) {
    print("Current User Details:");
    print("UID: ${currentUser.uid}");
    print("Name: ${currentUser.displayName}");
    print("Email: ${currentUser.email}");
    print("Recipe Details: ${recipeDetails}");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        String selectedList = "Planning"; // Default selected list

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    "List Editor",
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedList,
                    decoration: InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 64, 129), // Border color
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 64, 129), // Border color
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 64, 129), // Border color
                          width: 2,
                        ),
                      ),
                    ),
                    items: ["Planning", "Cooking", "Cooked"].map((String list) {
                      return DropdownMenuItem<String>(
                        value: list,
                        child:
                        Text(list, style: TextStyle(fontFamily: 'Ubuntu')),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedList = value ?? "Planning";
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: Colors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(130, 60), // Increased size
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Color.fromARGB(255, 255, 64, 129),
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Increased font size
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final recipe = {
                            'id': recipeDetails['id'].toString(),
                            'title': recipeDetails['title'],
                            'image': recipeDetails['image'],
                          };

                          // Save the recipe to Firestore
                          bool success = await _saveToUserList(
                            context,
                            currentUser.uid,
                            selectedList,
                            recipe,
                          );

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text("Recipe saved to $selectedList list!"),
                                backgroundColor: Colors.blueGrey,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Error saving recipe. Please try again."),
                                backgroundColor: Colors.blueGrey,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: Colors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(130, 60), // Increased size
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Color.fromARGB(255, 255, 64, 129),
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Increased font size
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<bool> _saveToUserList(
      BuildContext context,
      String userId,
      String listType,
      Map<String, dynamic> recipe,
      ) async {
    try {
      // Reference to the user's recipe lists document
      DocumentReference userListRef =
      FirebaseFirestore.instance.collection('recipe_lists').doc(userId);

      // Fetch the user's list document
      DocumentSnapshot userSnapshot = await userListRef.get();

      if (!userSnapshot.exists) {
        // Initialize document if it doesn't exist (for new users)
        await userListRef.set({
          'userId': userId,
          'planning': [],
          'cooking': [],
          'cooked': [],
          'favorites': [],
        });
      }

      // Remove the recipe from all other lists to ensure it exists only in one list
      await userListRef.update({
        'planning': FieldValue.arrayRemove([recipe]),
        'cooking': FieldValue.arrayRemove([recipe]),
        'cooked': FieldValue.arrayRemove([recipe]),
      });

      // Add the recipe to the selected list
      await userListRef.update({
        listType.toLowerCase(): FieldValue.arrayUnion([recipe]),
      });

      return true;
    } catch (e) {
      print("Error saving recipe to list: $e");
      return false;
    }
  }
}
