import 'dart:convert';

import 'package:http/http.dart'as http;
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
      return jsonData;
    }else{
      throw Exception("something went wrong");
    }


  }
}