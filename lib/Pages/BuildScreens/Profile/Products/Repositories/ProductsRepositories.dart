

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class ProductsRepositories{


  ServerResponse message=ServerResponse();


  Future<bool> add_percents({body}) async {
    try{
      var response= await ALApiClient(bodyData: body,methode: 'add_percents',).request(isMulti: true);

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

  Future<bool> show_percents({body}) async {
    try{
      var response= await ALApiClient(bodyData: body,methode: 'show_percents',).request(get: true,isPagination: true);

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
