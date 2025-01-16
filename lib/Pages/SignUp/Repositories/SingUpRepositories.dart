



import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class SingUpRepositories
{

  ServerResponse message=ServerResponse();



  Future<bool> register_customer({required body}) async {
    try{
      var response= await ALApiClient(methode: 'register-customer',bodyData: body).request();

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





  Future<bool> display_all_cities() async {
    try{
      var response= await ALApiClient(methode: 'display-all-cities',bodyData: {'country_id':'1'}).request(get: true);

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