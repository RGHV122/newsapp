import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/news.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';

const String testDevice = "81FD9118B38595CB3928A88F4FFD39EE";
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading=true;
  static String bannerId="ca-app-pub-6298255171961713/9076982543";
  static String appId="ca-app-pub-6298255171961713~6833962582";
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,

  );


  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,

      listener: (MobileAdEvent event) {
        print("BannerAd event $event");

      },

    );
  }




  @override
  void initState() {
    // TODO: implement initState
    FirebaseAdMob.instance.initialize(appId: appId);
    _bannerAd = createBannerAd()..load()..show();
    super.initState();
    getNews();
  }
  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Future<void> getLocationpermission() async{
    PermissionStatus permission = await LocationPermissions().checkPermissionStatus();
    if(permission!=PermissionStatus.granted){
       await LocationPermissions().requestPermissions();
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
  upDateNews() async{
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
              color: Colors.amber,
            )),
          ],
        ),
        centerTitle: true,
      ),
      body: _loading?Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):GestureDetector(
        onHorizontalDragUpdate: (details) {
            if (details.delta.dx < 40) {
              newsapipage+=1;
              setState(() {
                _loading=false;
              });
              upDateNews();
            }
            else if (details.delta.dx > 40) {
              if(newsapipage>1){
                newsapipage-=1;
                setState(() {
                  _loading=false;
                });
                upDateNews();

              }

            }
          },
        child: SingleChildScrollView(
          child: Container(

            padding: EdgeInsets.only(top: 35),
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
                 ),
               ],
             ),
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
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}

