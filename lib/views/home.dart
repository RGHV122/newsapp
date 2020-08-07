import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/news.dart';
import 'package:newsapp/services/admob_service.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading=true;
  final ams=AdMobService();
  final _nativeAdController = NativeAdmobController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }
  Future<void> getLocationpermission() async{
    PermissionStatus permission = await LocationPermissions().checkPermissionStatus();
    if(permission!=PermissionStatus.granted){
      PermissionStatus permission = await LocationPermissions().requestPermissions();
    }
  }
  getNews() async{
    await getLocationpermission();
    News newslistget = News();
    await newslistget.getlocation();
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
        child: Column(
          children: <Widget>[

            Container(

              padding: EdgeInsets.only(top: 16),
               child: Column(
                 children: <Widget>[
                   Container(
                     height: 90,
                     padding: EdgeInsets.all(10),
                     margin: EdgeInsets.only(bottom: 20.0),
                     child: new NativeAdmob(
                       // Your ad unit id
                       adUnitID: ams.getBannerAdId(),
                       error: Text("Failed to load the ad"),
                       controller: _nativeAdController,
                       type: NativeAdmobType.banner,
                     ),
                   ),
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
                   ),
                 ],
               ),
            ),
          ],
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

