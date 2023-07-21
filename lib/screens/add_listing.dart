import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

//All Image related methods from https://www.porkaone.com/2022/07/how-to-upload-images-and-display-them.html
//ImagePicker to choose images
final ImagePicker picker = ImagePicker();

//Function to choose an image from camera or gallery
Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

//popup dialog
//TODO: This method doesn't work. Not launching files app
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
                      picker.pickImage(source: ImageSource.gallery);
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
                      picker.pickImage(source: ImageSource.camera);
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
                //TODO: Add image uploading under here:
                ElevatedButton(
                  onPressed: (){
                    myAlert();
                  }, 
                  child: Text('Choose an Image')),
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
            ]
            ),
        ),
      ),
    );
  }
}