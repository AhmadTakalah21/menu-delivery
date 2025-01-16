

import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class ProfileRepositories extends GetxController
{
  ServerResponse message=ServerResponse();

  Future<bool> display_profile() async {
    try{
      var response= await ALApiClient(methode: 'display-profile',).request(get: true);

      if(response.runtimeType!=bool)
      {
        message=dataServerResponseFromJson(response).first;
        if(message.state==1)
        {
          return true;
        }
        else
        {
          return false ;
        }
      }
      else
      {
        return false ;
      }

    }
    catch (e)
    {
      print("Error Api login Hear: $e");
      return false;
    }

  }


  Future<bool> update_profile({dynamic body}) async {
    try{
      var response= await ALApiClient(bodyData: body,methode: 'update-profile',).request();

      if(response.runtimeType!=bool)
      {
        message=dataServerResponseFromJson(response).first;
        if(message.state==1)
        {
          return true;
        }
        else
        {
          return false ;
        }
      }
      else
      {
        return false ;
      }

    }
    catch (e)
    {
      print("Error Api login Hear: $e");
      return false;
    }

  }

  Future<bool> update_password({dynamic body}) async {
    try{
      var response= await ALApiClient(bodyData: body,methode: 'update-password',).request();

      if(response.runtimeType!=bool)
      {
        message=dataServerResponseFromJson(response).first;
        if(message.state==1)
        {
          return true;
        }
        else
        {
          return false ;
        }
      }
      else
      {
        return false ;
      }

    }
    catch (e)
    {
      print("Error Api login Hear: $e");
      return false;
    }

  }


}