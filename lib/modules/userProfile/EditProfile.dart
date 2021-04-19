import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditData extends StatefulWidget {
  QueryDocumentSnapshot e;
  EditData(QueryDocumentSnapshot e){
    this.e=e;
  }
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<EditData> {
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection('Accounts');
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController accountnoController = TextEditingController();
  TextEditingController accountnameController = TextEditingController();
  TextEditingController banknameController = TextEditingController();


  bool hidepassword= true;
  bool buttonhideshow=false;
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController = TextEditingController()..text=widget.e['UserName'];
    emailController = TextEditingController()..text=widget.e['Email'];
    passwordController = TextEditingController()..text=widget.e['Password'];
    accountnoController = TextEditingController()..text=widget.e['AccountNo'];
    accountnameController = TextEditingController()..text=widget.e['AccountName'];
    banknameController = TextEditingController()..text=widget.e['BankName'];
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text('Add New Account'),
      ),
      body: SafeArea(
        // child: ,
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text('User Name',style: TextStyle(fontSize: 12,color: Colors.black),),
            ),
            SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          //  keyboardType: TextInputType.number,
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color: Colors.greenAccent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: 'User Name'
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text('Email',style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          //   keyboardType: TextInputType.number,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color: Colors.greenAccent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: 'Email'
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text('Password',style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          obscureText: hidepassword,
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border:
                              OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green,width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        hidepassword=!hidepassword;
                                      });
                                    },
                                    child: Icon(Icons.visibility,color: Colors.blue,)),
                              ),
                              hintText: 'Password'
                          ),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text('Account No.',style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: accountnoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color: Colors.greenAccent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: 'Account Number'
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text('Account Name',style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          //   keyboardType: TextInputType.number,
                          controller: accountnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color: Colors.greenAccent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: 'Account Name'
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text('Bank Name',style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width/1.2,
                        child: TextFormField(
                          //   keyboardType: TextInputType.number,
                          controller: banknameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              focusedBorder:OutlineInputBorder(
                                // borderSide: BorderSide(color:containercolor),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color: Colors.greenAccent),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: 'Bank Name'
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  /* CircleAvatar(
                    radius: 30.0,

                     backgroundImage: Image.asset('assets/'),
                    backgroundColor: Colors.red,//Colors.transparent,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: Center(child: _image == null?Image.asset('assets/camera.png',width: 30,height: 30,): Image.file(_image,fit: BoxFit.fill,width: 80,height: 80,),),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey),
                        ),
                        onTap: (){
                          getImage();
                          print('here');
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 60,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.blue.withOpacity(0.5),
                                blurRadius: 20 ,
                              ),

                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: RaisedButton(
                            child: Text('Modify',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),),
                            onPressed: buttonhideshow?null:()async{
                              if (_formKey.currentState.validate()){
                                setState(() {
                                  buttonhideshow=true;
                                });
                                await widget.e.reference.update({'UserName':usernameController.text,
                                  'Email':emailController.text,
                                  'Password': passwordController.text,
                                  'AccountNo':accountnoController.text,
                                  'AccountName':accountnameController.text,
                                  'BankName':banknameController.text
                                }).then((value) {
                                  usernameController.text="";
                                  emailController.text="";
                                  accountnoController.text="";
                                  passwordController.text="";
                                  accountnameController.text="";
                                  banknameController.text="";
                                  setState(() {
                                    buttonhideshow=false;
                                  });
                                  Navigator.pop(context);
                                });

                              }

                              //  Navigator.pushNamed(context, "Account");
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
