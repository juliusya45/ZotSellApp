import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddListing extends StatefulWidget {
  const AddListing({super.key});

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {

//text controllers for the different fields that need to be filled out
final _itemTitleController = TextEditingController();

//String that is used with setState to display error messages
String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Listing',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
          ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Enter a Listing Title:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 7),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _itemTitleController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Listing Title',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
            ]
            ),
        ),
      ),
    );
  }
}