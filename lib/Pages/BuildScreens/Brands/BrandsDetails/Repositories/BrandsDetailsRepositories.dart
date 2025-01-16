




import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';
import 'package:shopping_land_delivery/Model/Repositories/ApiClient/ALApiClient.dart';

class BrandsDetailsRepositories
{
  ServerResponse message=ServerResponse();

  Future<bool> display_types({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'display-types',).request(get: true,isPagination: true);

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



  Future<bool> search_by_brand({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'search-by-brand',).request(get: true,isPagination: true);

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



  Future<bool> display_master_categories({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'display-master-categories',).request(get: true);

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

  Future<bool> display_sub_categories({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'display-sub-categories',).request(get: true);

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


  Future<bool> display_items({bodyData}) async {
    try{
      var response= await ALApiClient(bodyData: bodyData,methode: 'display-items',).request(get: true,isPagination: true);

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