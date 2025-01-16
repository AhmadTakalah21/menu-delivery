

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class CategoryDetailsRepositories {

  ServerResponse message=ServerResponse();

  Future<bool> store_search({bodyData}) async {
    try{
      var response= await ALApiClient(methode: 'store_search', bodyData: bodyData,).request(get: true,isPagination: true);

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