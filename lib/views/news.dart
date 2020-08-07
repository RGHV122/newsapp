import 'dart:convert';

import 'package:newsapp/model/article_model.dart';
import 'package:http/http.dart' as http;
class News{
  List<ArticleModel> news=[];
  Future<void> getNews() async{
    String url="https://newsapi.org/v2/top-headlines?country=in&pageSize=5&apiKey=b90becb725d14144a04558f5526a665b";
    var response = await http.get(url);
    print("got news data");
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=="ok"){
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
      print("news getting error");
    }
  }

}