

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class StoreItemRepositories
{
  ServerResponse message=ServerResponse();

  Future<bool> show_item_store({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'show_item_store',).request(get: true);

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

  Future<bool> add_to_cart({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'add_to_cart',).request();

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