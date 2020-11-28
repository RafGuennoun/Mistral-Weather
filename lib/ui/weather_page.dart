import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/util.dart' as util;
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    
    return WeatherPageState();
  }
  
}

class WeatherPageState extends State<WeatherPage>
{

  final _citySearchController = TextEditingController();

  static final DateTime date = DateTime.now();
  static final DateFormat formatterDate = DateFormat.yMMMMd('en_US');
  final String dateNow = formatterDate.format(date);
  static final DateFormat formatterTime = DateFormat.Hm();
  final String timeNow = formatterTime.format(date); 

  String city=util.defaultCity;

  int majorer ( double d)
 {
    if( (d - d.toInt()) >= 0.5)
    {
      return (d.toInt()+1);
    }
    else
    {
      return d.toInt();
    }
 }

  String capitalize(String s){
    return s[0].toUpperCase() + s.substring(1);
  } 

  Future<Map> getCurrentWeather(String appId, String city) async{
    
    String apiURL = "http://api.openweathermap.org/data/2.5/weather?"
    "q=$city" //the city
    "&appid=$appId"  // the appid from the utils
    "&units=metric"; // metric for C° and imperial for F°

    
    http.Response response = await http.get(apiURL);

    return json.decode(response.body);
  }

  Future<Map> get5DaysWeather(String appId, String city) async{
    
    String apiURL = "http://api.openweathermap.org/data/2.5/forecast?"
    "q=$city" //the city
    "&appid=$appId" // the appid from the utils
    "&units=metric"; // metric for C° and imperial for F°
   
    http.Response response = await http.get(apiURL);

    return json.decode(response.body);
  }

  void showWeather() async
  {
    Map _weatherData = await get5DaysWeather(util.appId, util.defaultCity);
    //print(_weatherData.toString());
    //print("khra");
    print("temp is = ${_weatherData['list'][0]['main']['temp'].toString()}");
  }

  Future<String> getTemp() async
  {
    Map _weatherData = await get5DaysWeather(util.appId, util.defaultCity);
    //print(_weatherData.toString());
    //print("khra");
    print("temp is = ${_weatherData['list'][0]['main']['temp'].toString()}");
    return _weatherData['list'][0]['main']['temp'].toString();
  }

  Widget updatePlaceNameWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      //future: get5DaysWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;
          
          return Text("${content['name'].toString()}",
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600 ),
                );
         // });
          // return Text("${content['name']}",
          //           style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
          //         );
        }
        else
        {
          return Text("Error 404",
                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
                );
        }
      });
  }

  Widget updateDateAndTimeNow(String date, String time)
  {
    return new FutureBuilder(
      //future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        return Text("$date , $time",
                          style: TextStyle(color: Colors.white, fontSize: 15), 
                        );
      });
  }
  
  Widget updateDataTempWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;
          
          return Text("${majorer(content['main']['temp'].toDouble()).toString()}",
                  style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.w300),
                );
         // });
          // return Text("${content['name']}",
          //           style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
          //         );
        }
        else
        {
          return Text("° C");
        }
      });
  }

  Widget updateIconTempWidget(String city, double height, double width)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;
          String icon = content['weather'][0]['icon']; 
          
          return Image.network(
            'http://openweathermap.org/img/w/$icon.png',
            height: height,
            width:  width,
            );
        }
        else
        {
          return Text("° C");
        }
      });

  
  }

  Widget updateMinMaxTempWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String min = "${majorer(double.parse(content['main']['temp_min'].toString())).toString()}°";
      
          String max = "${majorer(double.parse(content['main']['temp_max'].toString())).toString()}°";

          return Text("$min / $max",
                  style: TextStyle(color: Colors.white, fontSize: 13, ),
                );
         // });
          // return Text("${content['name']}",
          //           style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
          //         );
        }
        else
        {
          return Text("min / max");
        }
      });
  }

  Widget updateDescriptionTempWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String desc = capitalize("${content['weather'][0]['description'].toString()}");

          return Text("$desc",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                );
         // });
          // return Text("${content['name']}",
          //           style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
          //         );
        }
        else
        {
          return Text("min / max");
        }
      });
  }

  Widget updateTempRessentieWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String temp = "${majorer(double.parse(content['main']['feels_like'].toString())).toString()}";
      
          return Text("T° ressentie $temp°",
                  style: TextStyle(color: Colors.white, fontSize: 13, ),
                );
         // });
          // return Text("${content['name']}",
          //           style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600 ),
          //         );
        }
        else
        {
          return Text("min / max");
        }
      });
  }


  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double appBarheight = AppBar().preferredSize.height; 
    double displaySize = size.longestSide-appBarheight; 
    double mesure = displaySize/3;
    
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Mistral"),
      //   centerTitle: true,
      //   backgroundColor: Colors.pink,
      // ),

      body: Container(
        //color: Colors.grey[100],
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.indigo, Colors.cyan],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //stops: [0.0,1.0],
              tileMode: TileMode.clamp
            )
        ),

        child: ListView(
          children:<Widget> [

            //Champ de rech  + btn
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
              title: Container(
                height: appBarheight,
                width: size.shortestSide,
                //color: Colors.amber,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children:<Widget> [

                    Container(
                      height: appBarheight,
                      width: size.shortestSide,
                      //color: Colors.red[300],
                      child: Center(
                        child: Row(
                          children:<Widget> [
                            
                            
                            //TextField
                            Container(
                              height: appBarheight,
                              width: size.shortestSide*(5/6),
                              //color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: TextField(
                                    controller: _citySearchController,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      hintText: 'Enter city ?',
                                      prefixIcon: Icon(Icons.map, color: Colors.white,),
                                    ),
                                  ),
                                ),
                              )
                            ),

                            //Rechercher
                            Container(
                              height: appBarheight,
                              width: size.shortestSide*(1/6),
                              //color: Colors.white,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.search, color: Colors.white,),
                                  onPressed: () {
                                    city = _citySearchController.text;
                                    _citySearchController.clear();
                                    showWeather();
                                    setState(() {
                                      updatePlaceNameWidget("$city");
                                      updateDateAndTimeNow(dateNow, timeNow);
                                      updateDataTempWidget("$city");
                                      updateIconTempWidget("$city", (((mesure/4)*2)/4)*3.5, (((size.shortestSide/4)*3)/5)*2);
                                      updateMinMaxTempWidget("$city");
                                      updateTempRessentieWidget("$city");
                                      updateDescriptionTempWidget("$city");
                                    });
                                  }
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ) ,

              ),
            ),

            //Ville + Date + Heure
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.orange,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15.0), 
                  ),
                  height: appBarheight*(1.5),
                  width: size.shortestSide,
                  //color: Colors.amber,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Place - City
                        updatePlaceNameWidget("$city"),

                        SizedBox(height: 10),

                        //Date
                        updateDateAndTimeNow(dateNow, timeNow),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            myDivider(50,50),

            //Big Data
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  height: mesure,
                  width: size.shortestSide,
                  decoration: BoxDecoration(
                    //color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15.0), 
                  ),

                  child: Center(
                    child: ListView(
                      children: <Widget>[

                        Container(
                          height: (mesure/4)*3,
                          width: size.shortestSide,
                          //color: Colors.pink,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[

                                  //Up ( Temp + Icone)
                                  Container(
                                    height: (mesure/4)*2,
                                    width: (size.shortestSide/4)*3,
                                    //color: Colors.greenAccent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        
                                        // Icone
                                        Container(
                                          height: (((mesure/4)*2)/4)*3.5,
                                          width: (((size.shortestSide/4)*3)/5)*2,
                                          //color: Colors.blueAccent,
                                          child: Center(
                                            child: updateIconTempWidget("$city", (((mesure/4)*2)/4)*3.5, (((size.shortestSide/4)*3)/5)*2),
                                          ),
                                        ),
                                        
                                        SizedBox(width: 10,),

                                        // Temp C°
                                        Container(
                                          height: (((mesure/4)*2)/4)*3.5,
                                          width: (((size.shortestSide/4)*3)/5)*2,
                                          //color: Colors.pinkAccent,
                                          child: Center(
                                            child: Row(
                                              children:<Widget> [
                                                
                                                //Temp
                                                Container(
                                                  height: (((mesure/4)*2)/4)*3.5,
                                                  width: (((((size.shortestSide/4)*3)/5)*2)/8)*6,
                                                  //color: Colors.grey,
                                                  child: Center(
                                                    child: updateDataTempWidget("$city")
                                                  ),
                                                ),

                                                //°
                                                Container(
                                                  height: (((mesure/4)*2)/4)*3.5,
                                                  width: (((((size.shortestSide/4)*3)/5)*2)/8)*2,
                                                  //color: Colors.grey,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                                                    child: Text("°",
                                                      style: TextStyle(color: Colors.white, fontSize: 40),
                                                    ),
                                                  )
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),

                                        

                                      ],
                                    ),
                                  ),

                                  //SizedBox(height: 2,),

                                  //Down ( (Min Max) | (Temps ressentie ))
                                  Container(
                                    height: (mesure/4)*0.75,
                                    width: (size.shortestSide/4)*3,
                                    //color: Colors.green,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        //Min Max
                                        Container(
                                          height: (mesure/4)*0.75,
                                          width: (((size.shortestSide/4)*3)/5)*2,
                                          //color: Colors.pinkAccent,
                                          child: Center(
                                            child: updateMinMaxTempWidget("$city")
                                          ),
                                        ),

                                        VerticalDivider(
                                          color: Colors.white,
                                          thickness: 0.5,
                                          indent: 5,
                                          endIndent: 5,

                                        ),

                                        //Temp ressentie
                                        Container(
                                          height: (mesure/4)*0.75,
                                          width: (((size.shortestSide/4)*3)/5)*2,
                                          //color: Colors.pinkAccent,
                                          child: Center(
                                            child: updateTempRessentieWidget("$city")
                                            ),
                                        ),

                                        
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          height: (mesure/4),
                          width: size.shortestSide,
                          //color: Colors.pinkAccent,
                          child: Center(
                            child: updateDescriptionTempWidget("$city"),
                          ),
                        ),
                      ],
                    ),
                  ),


                ),
              ),
            ),

            myDivider(15,15),

            //Horaires Journee / Weather today
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure*1.125,
                width: size.shortestSide,
                //color: Colors.red,
                child: Column(
                  children: <Widget>[
                    
                    //Text Horaires
                    Container(
                      height: mesure/5,
                      width: size.shortestSide,
                      //color: Colors.grey,
                      child: Center(
                        child: titleText("Horaires"),
                      ),
                    ),

                    //Horaires
                    Container(
                      height: (mesure*1.125) - (mesure/5),
                      width: size.shortestSide,
                      //color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0,5,0,5),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            
                            SizedBox(width: 10,),

                            //1
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),

                            myVerticalDivider(),

                            //2
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),

                            myVerticalDivider(),

                            //3
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),

                            myVerticalDivider(),

                            //4
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),

                            myVerticalDivider(),

                            //5
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),
                            myVerticalDivider(),

                            //6
                            Container(
                              height: (mesure*1.125) - (mesure/5),
                              width: (size.shortestSide)/4,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18.0), 
                              ),
                            ),

                            SizedBox(width: 10,)

                          ],
                        ),
                         
                      ),

                    ),
                    

                  ],
                )
              ),
            ),

            myDivider(15,15),

            // 7Days
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure*(1.5),
                width: size.shortestSide,
                color: Colors.red,
                child: Column(
                  children: <Widget>[
                    
                    //Text Quotidien
                    Container(
                      height: mesure/5,
                      width: size.shortestSide,
                      color: Colors.grey,
                      child: Center(
                        child: titleText("QUOTIDIEN"),
                      ),
                    ),

                    //Horaires
                    Container(
                      height: (mesure*1.5) - (mesure/5),
                      width: size.shortestSide,
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            
                            //1
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),

                            myVerticalDivider(),

                            //2
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),

                            myVerticalDivider(),

                            //3
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),

                            myVerticalDivider(),

                            //4
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),

                            myVerticalDivider(),

                            //5
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),

                            myVerticalDivider(),

                            //6
                            Container(
                              height: (mesure*1.5) - (mesure/5),
                              width: (size.shortestSide)/4,
                              color: Colors.red,
                            ),
                          ],
                        ),
                         
                      ),

                    ),
                    

                  ],
                )
              ),
            ),


            myDivider(15,15),

            //Detail
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure,
                width: size.shortestSide,
                color: Colors.grey,
                child: Center(
                  child: Column(
                    children:<Widget>[

                      //Text Detalis
                      Container(
                        height: mesure/5,
                        width: size.shortestSide,
                        color: Colors.grey,
                        child: Center(
                          child: titleText("DETAILS") ,
                        ),
                      ),

                      //Details
                      Container(
                        height: mesure - (mesure/5),
                        width: size.shortestSide,
                        color: Colors.green,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children:<Widget> [

                            Container(
                              height: (mesure - (mesure/5))/2,
                              width: size.shortestSide,
                              color: Colors.red[300],
                              child: Center(
                                child: Row(
                                  children:<Widget> [
                                    
                                    Container(
                                      height: (mesure - (mesure/5))/2,
                                      width: size.shortestSide/2,
                                      color: Colors.red[400],
                                      child: Center(
                                        child: titleText("Rain %"),
                                      ),
                                    ),

                                    Container(
                                      height: (mesure - (mesure/5))/2,
                                      width: size.shortestSide/2,
                                      color: Colors.red[200],
                                      child: Center(
                                        child: titleText("Wind speed"),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            Container(
                              height: (mesure - (mesure/5))/2,
                              width: size.shortestSide,
                              color: Colors.red[300],
                              child: Center(
                                child: Row(
                                  children:<Widget> [
                                    
                                    Container(
                                      height: (mesure - (mesure/5))/2,
                                      width: size.shortestSide/2,
                                      color: Colors.red[100],
                                      child: Center(
                                        child: titleText("Humidity %"),
                                      ),
                                    ),

                                    Container(
                                      height: (mesure - (mesure/5))/2,
                                      width: size.shortestSide/2,
                                      color: Colors.red[300],
                                      child: Center(
                                        child: titleText("UV index"),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                

                          ],
                        ) ,
                      ),
                      


                    ],
                  )
                ),
              ),
            ),

            myDivider(15,15),


          ],
        ),

      ),
 


     
    );
  }

}

  Widget myDivider(double start, double end){
  return Divider(
              color: Colors.white,
              thickness: 0.5,
              indent: start,
              endIndent: end,
            );
  }

  Widget myVerticalDivider(){
  return VerticalDivider(
              color: Colors.white,
              thickness: 0.5,
              indent: 5,
              endIndent: 5,
            );
  }

  Widget titleText(String text)
  {
    return Text(
      "$text",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        //fontWeight: FontWeight.w100
      ),
    );
  }

 