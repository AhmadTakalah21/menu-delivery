

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class NotificationsRepositories
{
  ServerResponse message=ServerResponse();




  Future<bool> show_notifications({dynamic body}) async {
    try{
      var response= await ALApiClient(bodyData: body,methode: 'show_notifications',).request(isPagination: true);

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