

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';

import '../../../../../Model/Repositories/ApiClient/ALApiClient.dart';

class WithdrawalRepositories
{

  ServerResponse message=ServerResponse();

  Future<bool> show_withdrawals({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'show_withdrawals',).request(get: true);

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


  Future<bool> withdraw_money({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'withdraw_money',).request();

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