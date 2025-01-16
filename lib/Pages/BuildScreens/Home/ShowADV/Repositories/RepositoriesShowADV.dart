
// ignore_for_file: non_constant_identifier_names

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';


class RepositoriesShowADV
{
  ServerResponse message=ServerResponse();

  Future<bool> get_one_adv({body}) async {
    try{
      var response= await ALApiClient(bodyData:body ,methode: 'get_one_adv',).request(get: true);

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