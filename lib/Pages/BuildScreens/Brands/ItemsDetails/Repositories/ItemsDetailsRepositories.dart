




import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class ItemsDetailsRepositories
{
  ServerResponse message=ServerResponse();

  Future<bool> display_item_by_id({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'display-item-by-id',).request(get: true,isPagination: true);

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


  Future<bool> add_item_to_cart({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'add-item-to-cart',).request(isMulti: true);

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