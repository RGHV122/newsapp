import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';

var newsapipage=1;
var errorgettingnews=true;
class News{
  String country="in";
  List<ArticleModel> news=[];

  Future<void> getlocation() async{

    if((await Geolocator().isLocationServiceEnabled()) == true){
      GeolocationStatus locationStatus  = await Geolocator().checkGeolocationPermissionStatus();
      if(locationStatus == GeolocationStatus.granted){
        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
        final coordinates = new Coordinates(position.latitude, position.longitude);
        var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        print(address.first.countryName);
        if(address.first.countryName == "USA"){
          country="us";
        }
      }
      else{
        print("location not available");
      }

    }
  }
  Future<void> getNewsfromapi() async{
    String url="https://newsapi.org/v2/top-headlines?country=$country&pageSize=5&page=$newsapipage&apiKey=b90becb725d14144a04558f5526a665b";
    var response = await http.get(url);
    news=[];
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=="ok"){
      errorgettingnews=false;
      print("got news data");
      jsonData['articles'].forEach((element) {
        if(element["urlToImage"]!=null && element["description"]!=null){
          ArticleModel am = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['context'],
          );
              news.add(am);
        }

      });
    }
    else{
      errorgettingnews=true;
      print("news getting error");
    }
  }

}