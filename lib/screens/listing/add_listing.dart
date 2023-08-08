import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/zotuser.dart';
import 'package:zot_sell/screens/listing/preview_listing_screen.dart';

class AddListing extends StatefulWidget {
  const AddListing({super.key, required this.user});

  final Zotuser user;

  @override
  State<AddListing> createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {

//text controllers for the different fields that need to be filled out
final _itemTitleController = TextEditingController();
final _itemDescriptionController = TextEditingController();
final _itemPriceController = TextEditingController();
final _itemQuantityController = TextEditingController();

//For Storing tags:
int conditionTag = 0;
int typeTag = 0;

List<String> conditionList = ["New", "Like-New", "Lightly Used", "Used", "Heavily Used", "Broken"];
List<String> typeList = ["Clothing", "Accessory", "Tech", "Jewelery", "Shoes"];
List<String> finalTagList = [];
List<String> custTagList = [];

//String that is used with setState to display error messages
String errorMsg = '';

//Error msg for when fields aren't filled in:
String filledErrMsg = '';

//XFile seems to be a variable that stores the img?
XFile? image;

//XFile list to store multiple images:
List<XFile> imageFiles = [];

//All Image related methods from https://www.porkaone.com/2022/07/how-to-upload-images-and-display-them.html
//ImagePicker to choose images
final ImagePicker picker = ImagePicker();

bool areFieldsNotEmpty()
{
  if(_itemTitleController.text.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Title Listing';
    });
    return false;
  }
  else if(_itemDescriptionController.text.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Put a Description';
    });
    return false;
  }
  else if(_itemPriceController.text.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Add an Item Price';
    });
    return false;
  }
  else if(_itemQuantityController.text.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Specify Quantity';
    });
    return false;
  }
  else if(imageFiles.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Add Image(s)';
    });
    return false;
  }
  else if(custTagList.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Add a Custom Tag';
    });
    return false;
  }
  else if(finalTagList.isEmpty)
  {
    setState(() {
      filledErrMsg = 'Please Select at least 3 Tags';
    });
    return false;
  }
  else
  {
    return true;
  }
}

void checkThenAdd(String tag)
{
  if(!finalTagList.contains(tag))
  {
    finalTagList.add(tag);
  }
}

//THIS ONE WORKS!!!
//https://www.fluttercampus.com/guide/183/how-to-make-multiple-image-picker-in-flutter-app/
void selectMultiImg() async{
  try{
    var pickedfiles = await picker.pickMultiImage();
    //you can use ImageCourse.camera for Camera capture
    // ignore: unnecessary_null_comparison
    if (imageFiles.length < 3) {
      setState(() {
          //keep adding to the list
          for (var picked in pickedfiles) {
            //check to make sure there are at most 3 imgs:
            if(imageFiles.length < 3)
            {
              imageFiles.add(picked);
            }
          }
          errorMsg = '';
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

    final user = widget.user;

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
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                SizedBox(height: 10),
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
                const Text(
                'Add Tags:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Column(
                    children: [
                      Text(
                        "Item Condition",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      ChipsChoice<int>.single(
                        value: conditionTag, 
                        onChanged: (val) => setState(() => conditionTag = val),
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: conditionList,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                        choiceCheckmark: true,
                        ),
                        SizedBox(height: 10),
                        Text(
                        "Type of Item",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      ChipsChoice<int>.single(
                        value: typeTag, 
                        onChanged: (val) => setState(() => typeTag = val),
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: typeList,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                        choiceCheckmark: true,
                        ),
                        SizedBox(height: 10),
                        Text(
                        "Custom Tags (Hit space to add a tag)",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        ChipTags(
                          list: custTagList,
                          chipColor: Color.fromARGB(255, 214, 237, 255),
                          iconColor: Colors.blue,
                          textColor: Colors.blue,
                          chipPosition: ChipPosition.above,
                          createTagOnSubmit: false,
                          decoration: InputDecoration(hintText: "Add at least 1 custom tag"),
                          keyboardType: TextInputType.text,
                        )
                    ]
                    ),
                ),
                SizedBox(height: 10,),
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
                Center(
                  child: Text(
                    filledErrMsg,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red
                      ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                  onPressed: (){
                    //uses a method that checks to see if tag already exists in the list so there are no duplicates
                    checkThenAdd(conditionList[conditionTag]);
                    checkThenAdd(typeList[typeTag]);
                    for (var tag in custTagList) {
                      checkThenAdd(tag);
                    }
                    if (areFieldsNotEmpty()) {
                      var newListing = AppListings(
                        docId: '', 
                        time: Timestamp.now(), 
                        description: _itemDescriptionController.text, 
                        imgUrl: [], 
                        tags: finalTagList, 
                        itemTitle: _itemTitleController.text, 
                        meetingSpot: 'meetingSpot', 
                        price: _itemPriceController.text, 
                        quantity: _itemQuantityController.text, 
                        user: user.uid);
                        Navigator.push(
                          context, MaterialPageRoute(
                            settings: const RouteSettings(name: '/preview_listing'),
                            builder: (context) => PreviewListingScreen(listingItem: newListing, zotuser: user, images: imageFiles,)
                            )
                        );
                    }
                  },

                  child: Text(
                    'Preview Listing',
                    style: TextStyle(fontSize: 20
                    )
                  )
                  
                  ),
                  ),
                  SizedBox(height: 20,)
                
            ]
            ),
        ),
      ),
    );
  }
}