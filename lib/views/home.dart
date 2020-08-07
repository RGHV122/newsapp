import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
    
  }
  getNews() async{
    News newslistget = News();
    await newslistget.getNews();
    articles = newslistget.news;
    setState(() {
      _loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("News"),
            Text("Now",style: TextStyle(
              color: Colors.teal,
            )),
          ],
        ),
        centerTitle: true,
      ),
      body: _loading?Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 16),
           child: Column(
          children: <Widget>[
            Container(

              child: ListView.builder(
                  itemCount:articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index) {
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      description: articles[index].description,
                      url: articles[index].url,
                    );
                  }),
            )
          ],
          ),
        ),
      ),

    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl,title,description,url;
  BlogTile({ @required this.imageUrl,@required this.title,@required this.description,this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(url);
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => ArticleView(
            blogUrl: url,
          )
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl)
            ),
            SizedBox(height: 8,),
            Text(title,style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            ),
            SizedBox(height: 8,),
            Text(description,style: TextStyle(
              color: Colors.black54,

            ),
              ),
          ],
        ),
      ),
    );
  }
}

