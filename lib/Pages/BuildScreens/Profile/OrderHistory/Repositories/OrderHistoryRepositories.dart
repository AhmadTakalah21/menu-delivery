



import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';

import '../../../../../Model/Repositories/ApiClient/ALApiClient.dart';

class OrderHistoryRepositories
{

  ServerResponse message=ServerResponse();

  Future<bool> display_orders({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'show_order',).request(get: true,isPagination: true);

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
  Future<bool> changeActiveToWork({dynamic bodyData}) async {
    try {
      // استدعاء API باستخدام ALApiClient
      var response = await ALApiClient(
        bodyData: bodyData,
        methode: 'not_available',
      ).request(get: true); // لاحظ أن الطلب من النوع GET

      // التحقق من نوع الاستجابة
      if (response.runtimeType != bool) {
        message = dataServerResponseFromJson(response).first;
        if (message.state == 1) {
          return true; // تم التحديث بنجاح
        } else {
          return false; // حدث خطأ أثناء التحديث
        }
      } else {
        return false; // استجابة غير صالحة
      }
    } catch (e) {
      print("Error Api active-to-work: $e");
      return false; // حدث خطأ أثناء الاستدعاء
    }
  }


  Future<bool> display_delivery_type({dynamic bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData ,methode: 'display-delivery-type',).request(get: true,isPagination: true);

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