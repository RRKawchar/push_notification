import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService{


  Future<void> sendDeviceToken(String deviceToken)async{
    const url="https://api.newstube.app/apiv5/api/create.php";
    Map<String,dynamic> body={

      "device_id":deviceToken,
      "device_state":'on',
    };
    print('DeviceToken : $deviceToken');
    final uri=Uri.parse(url);
    final response=await http.post(uri,body: jsonEncode(body));
    if(response.statusCode==200){

      var jsonData=jsonDecode(response.body);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('generalId', jsonData['general_id']);
        print("General Id==${preferences.get('generalId')}");




      return jsonData;
    }else{
      throw Exception("something went wrong");
    }


  }

  Future<void> deleteToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    const url="https://api.newstube.app/apiv5/api/delete.php";
    Map<String,dynamic> body={
      "general_id":preferences.getString('generalId')
    };
    final uri=Uri.parse(url);
    final response=await http.post(uri,body: jsonEncode(body));
    if(response.statusCode==200){
      print("General Id Removed=${preferences.getString('generalId')}");
      var jsonData=jsonDecode(response.body);
      print(jsonData);
      return jsonData;
    }else{
      throw Exception("something went wrong");
    }

  }
}