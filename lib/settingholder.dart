import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class SettingsHolder {
  int _clientID = 0;
  int _version = 0;
  String _firstName, _secondName, _phone, _pass;
  String _videoToPlay;

  setVideoToPlay(String ul) {
    _videoToPlay = ul;
  }

  getVideoToPlay() {
    return _videoToPlay;
  }


  Future loadSettings() async {

  var response = await http.post('https://alexakosheleva.ru/appapi/index.php', body: {'themode':'getrec','clientID':_clientID,'pass':getPass()});
print("Response status: ${response.statusCode}");
print("Response body: ${response.body}");
await new Future.delayed(const Duration(milliseconds: 100));
    return 0;
  }

Future saveSettings() async {
  print("BODY:"+'addrec:yes'+'firstName'+_firstName+'secondName'+_secondName+'phone'+_phone+'pass'+getPass());
    var response = await http.post('https://alexakosheleva.ru/appapi/index.php', body: {'themode':'addrec','firstName':_firstName,'secondName':_secondName,'phone':_phone,'pass':getPass()});
print("Response status: ${response.statusCode}");
print("Response body: ${response.body}");
await new Future.delayed(const Duration(milliseconds: 100));
    return response.body.toString();
  }

  getID() {
    print ("clientID in func is:"+_clientID.toString());
    return _clientID;
  }

setID(int cID) {
    _clientID = cID;
  }
  getVersion() {
    return _version;
  }

   setVersion(int vers)  {
    _version = vers;
  }

  getName(int nameindex) {
    switch (nameindex) {
      case 0:
        return _firstName;
        break;
      case 1:
        return _secondName;
        break;
      default:
    }
  }

    setName(int nameindex, String name) {
    switch (nameindex) {
      case 0:
        _firstName = name;
        break;
      case 1:
        _secondName = name;
        break;
      default:
    }
  }

  getPhone() {
    return _phone;
  }

 setPhone(String phone) {
_phone = phone;  }

  getPass() {
    String pass;
    pass = generateMd5(_pass);
    return pass;
  }

  setPass(String pass) {
    _pass = pass;
  }

 

Future setSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('version', _version);
  
  await prefs.setString('firstName', _firstName);
  await prefs.setString('secondName', _secondName);
  await prefs.setString('phone', _phone);
    print ("settin version to $_version");
    _clientID = int.parse(await saveSettings());
await prefs.setInt('clientID', _clientID);

  }

Future getSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _version = (prefs.getInt('version') ?? 0);
  print('version is: $_version.');
  _clientID = (prefs.getInt('clientID') ?? 0);
  print('client ID is: $_clientID.');
  _firstName = (prefs.getString('firstName') ?? "-");
  print('First name is: $_firstName.');
  _secondName = (prefs.getString('secondName') ?? "-");
  print('Second name is: $_secondName.');
  _phone = (prefs.getString('phone') ?? "-");
  print('phone is: $_phone.');
 await new Future.delayed(const Duration(milliseconds: 1000));
 
  }

Future clearSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.remove('version');
prefs.remove('clientID');
prefs.remove('firstName');
prefs.remove('secondName');
prefs.remove('phone');
_version = 0;
_clientID = 0;
_firstName = "-";
_secondName = "-";
_phone = "-";


 await new Future.delayed(const Duration(milliseconds: 1000));
 
  }

}
