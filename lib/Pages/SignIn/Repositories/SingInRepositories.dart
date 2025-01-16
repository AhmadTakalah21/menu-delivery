



import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class SingInRepositories
{

  ServerResponse message=ServerResponse();

  // 'fcm_token':token
  // required String token
  Future<bool> login({required String email,required String password,}) async {
    try{
      var response= await ALApiClient(methode: 'login',bodyData: {'locale':'ar','username':email,'password':password}).request();

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