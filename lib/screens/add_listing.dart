import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/listings.dart';

class AddListing extends StatefulWidget {
  const AddListing({super.key});

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {

//text controllers for the different fields that need to be filled out
final _itemTitleController = TextEditingController();
final _itemDescriptionController = TextEditingController();
final _itemPriceController = TextEditingController();
final _itemQuantityController = TextEditingController();

//String that is used with setState to display error messages
String errorMsg = '';

//XFile seems to be a variable that stores the img?
XFile? image;

//XFile list to store multiple images:
List<XFile> imageFiles = [];

//All Image related methods from https://www.porkaone.com/2022/07/how-to-upload-images-and-display-them.html
//ImagePicker to choose images
final ImagePicker picker = ImagePicker();

//THIS ONE WORKS!!!
//https://www.fluttercampus.com/guide/183/how-to-make-multiple-image-picker-in-flutter-app/
void selectMultiImg() async{
  try{
    var pickedfiles = await picker.pickMultiImage();
    //you can use ImageCourse.camera for Camera capture
    // ignore: unnecessary_null_comparison
    if (imageFiles.length < 3) {
      setState(() {
        //while the # of images in the list is less than 3
        while (imageFiles.length < 3) {
          //keep adding to the list
          for (var picked in pickedfiles) {
              imageFiles.add(picked);
            }
          errorMsg = '';
        }
      });
    }
    else{
      //warn the user if they selected too many
      setState(() {
          errorMsg = 'The max # of images allowed is 3. Selected Image(s) were not added';
      });
    }
  }catch (e) {
      print("error while picking file.");
      print(e);
  }
}

//Function to choose an image from camera or gallery
Future getImage(ImageSource media) async {
  try {
  var img = await picker.pickImage(source: media);
  if (imageFiles.length < 3) {
    setState(() {
      imageFiles.add(img!);
    });
    errorMsg = '';
  }
  else
  {
    setState(() {
          errorMsg = 'The max # of images allowed is 3. Image was not added';
      });
  }
} on Exception catch (e) {
  // TODO
  print(e);
}
}
  //TODO: CAN'T LIMIT # OF IMAGES SELECTED HERE. NEED TO A CHECK AND ONLY SELECT FIRST 3 DOWN THE LINE

//Function to select multiple images:

//popup dialog
void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      selectMultiImg();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Listing Title:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  textAlign: TextAlign.left,
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
                SizedBox(height: 10),
                const Text(
                'Upload Photo(s):',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 5),
                Text('Please select up to 3 images of the item you are listing'),
                //TODO: Add image uploading under here:
                ElevatedButton(
                  onPressed: (){
                    myAlert();
                  }, 
                  child: Text('Choose Image(s)')),
                //TODO: Show selected images below:
                 imageFiles != null?Wrap(
                     children: imageFiles!.map((imageone){
                        return Stack(
                          alignment: Alignment.topRight,
                           children:[Card( 
                              child: Container(
                                 height: 118, width:118,
                                 child: Image.file(File(imageone.path)),
                              ),
                           ),
                           //add button here for user to press to delete selected image
                           IconButton(
                            onPressed: (){
                            //when delete button is pressed for the image delete that selected image
                            setState(() {
                              imageFiles.remove(imageone);
                              errorMsg = '';
                            });
                           }, 
                           icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            )
                            ),
                           ]
                        );
                     }).toList(),
                  ):Text(
                    "No Image Selected Yet",
                    style: TextStyle(fontSize: 20),
                  ),
                //error text
                Text(
                  errorMsg,
                  style: TextStyle(
                    color: Colors.red
                  )
                  ),
                SizedBox(height: 10),
                const Text(
                'Description:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                //Should be more like a paragraph text input box
                child: TextField(
                  maxLines: null,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.left,
                  controller: _itemDescriptionController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Description',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                'Item Price:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  controller: _itemPriceController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Price',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                'Number Available:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  controller: _itemQuantityController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Quantity',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                  onPressed: (){
                    var newListing = AppListings(
                      docId: '', 
                      time: 'time', 
                      description: _itemDescriptionController.text, 
                      imgUrl: '', 
                      tags: [], 
                      itemTitle: _itemTitleController.text, 
                      meetingSpot: 'meetingSpot', 
                      price: _itemPriceController.text, 
                      quantity: _itemQuantityController.text, 
                      user: 'test user');
                  },
                  child: Text(
                    'Preview Listing',
                    style: TextStyle(fontSize: 20
                    )
                  ))),
                
            ]
            ),
        ),
      ),
    );
  }
}