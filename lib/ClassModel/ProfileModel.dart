


import 'package:flutter/cupertino.dart';

enum ProfileModelType
{
  changePhone,
  changePassword,
  changeName,
  changeCity,
  logOut,
  title,

}
enum ProfileModelStyleType
{
  title,
  onTap,
  dropDown,
  textForm,
  logOut,
}

class ProfileModel {

  String title;
  bool? withBorder;
  bool? withPhone;
  TextEditingController? controller;
  ProfileModelType type;
  ProfileModelStyleType styleTypeType;
  ProfileModel({this.withPhone,this.controller,this.withBorder,required this.title,required this.type,required this.styleTypeType});

}