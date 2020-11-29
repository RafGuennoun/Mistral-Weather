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

  // void showWeather() async
  // {
  //   Map content = await get5DaysWeather(util.appId, util.defaultCity);
  //   //print(_weatherData.toString());
  //   //print("khra");
  //   //print("temp is = ${_weatherData['list'][0]['main']['temp'].toString()}");

  //   String temp = "${majorer(double.parse(content['list'][0]['main']['temp'].toString())).toString()}";

  //   String icon = content['list'][0]['weather'][0]['icon']; 

  //   String humidity = "${content['list'][0]['main']['humidity'].toString()}";

  //   int time = content['list'][0]['dt']*1000;


  //   //Settinig the date from Epoch (UNIX timestamp) to human readable time
  //   var dateFormat = new DateFormat.H();
  //   //var timeFormat = new DateFormat.jm();
    
  //   var realDate = new DateTime.fromMicrosecondsSinceEpoch(time*1000 , 
  //     isUtc: true);
  //   //var realTime = new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000 , isUtc: true);
  //   //We multiply the time * 1000 to get in in millisecondes 

  //   var date = dateFormat.format(realDate);
  //   //var time = timeFormat.format(realTime);

  //   int tn = DateTime.now().toUtc().millisecondsSinceEpoch;

  //        print("Content dt = ${time.toString()}");
  //        print("Epoach now = $tn");
  //        print("real date = ${realDate.toString()}");
  //        print("Time 5 days ====================== ${date.toString()}:00");
  //        print("Time now $timeNow");

  // }

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
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;
          
          return Text("${content['name'].toString()}",
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600 ),
                );
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
          return Text("No °");
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
          return Text("No Icon");
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
          return Text("Min° / Max°");
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
          return Text("Description");
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
          return Text("T° ressentie");
        }
      });
  }

  Widget updateCloudWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String clouds = "${content['clouds']['all'].toString()}";
          
          return Text("$clouds %",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("%");
        }
      });
  }

  Widget updateHumidityWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String hum = "${content['main']['humidity'].toString()}";
          
          return Text("$hum %",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("%");
        }
      });
  }

  Widget updateWindSpeedWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String speed = "${content['wind']['speed'].toString()}";
          
          return Text("$speed m/s",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("No speed");
        }
      });
  }

  Widget updateWindDirectionWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String dir = "${content['wind']['deg'].toString()}";
          
          return Text("$dir °",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("No Direction");
        }
      });
  }

  Widget updatePressureWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String press = "${content['main']['pressure'].toString()}";
          
          return Text("$press hPa",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("No Pressure");
        }
      });
  }

  Widget updateVisibilityWidget(String city)
  {
    return new FutureBuilder(
      future: getCurrentWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String vis = "${content['visibility'].toString()}";
          
          return Text("$vis MOR",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
         
        }
        else
        {
          return Text("No Visibility");
        }
      });
  }
 
  Widget updateWeatherTomorrowWidget(String city, int pos)
  {
    return new FutureBuilder(
      future: get5DaysWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          String temp = "${majorer(double.parse(content['list'][0]['main']['temp'].toString())).toString()}";

          String icon = content['list'][pos]['weather'][0]['icon']; 

          String humidity = "${content['list'][pos]['main']['humidity'].toString()}";

          int t = content['list'][pos]['dt']*1000;


          //Settinig the date from Epoch (UNIX timestamp) to human readable time
          var dateFormat = new DateFormat.H();
          //var timeFormat = new DateFormat.jm();
          
          var realTime = new DateTime.fromMicrosecondsSinceEpoch(t*1000 , 
            isUtc: true);

          var time = dateFormat.format(realTime);
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //time
              Text("${time.toString()}:00",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              //SizedBox(height: 20,),

              //icon
              Image.network('http://openweathermap.org/img/w/$icon.png'),

              //SizedBox(height: 10,),

              //humidity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.invert_colors, color: Colors.grey[100],),
                  SizedBox(width: 8),
                  Text("$humidity %",
                    style: TextStyle(color: Colors.grey[100]),
                  ),
                ],
              ),

              SizedBox(height: 10,),

              //tempertature
              Text("$temp°",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )

            ],
          );
         
        }
        else
        {
          return Text("...",
            style: TextStyle(color: Colors.white, fontSize: 25),
          );
        }
      });
  }

  Widget update5DaysWeatherWidget(String city, int pos)
  {
    return new FutureBuilder(
      future: get5DaysWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot ){
        //Whare we get all JSON data, we set up widgets 
        if(snapshot.hasData)
        {
          Map content = snapshot.data;

          //String dir = "${}";

          String tempmin = "${majorer(double.parse(content['list'][0]['main']['temp_min'].toString())).toString()}";

          String tempmax = "${majorer(double.parse(content['list'][0]['main']['temp_max'].toString())).toString()}";

          String icon = content['list'][pos]['weather'][0]['icon']; 

          String humidity = "${content['list'][pos]['main']['humidity'].toString()}";

          int t = content['list'][pos]['dt']*1000;


          //Settinig the date from Epoch (UNIX timestamp) to human readable time
          var dateFormat = new DateFormat.E();
          //var timeFormat = new DateFormat.jm();
          
          var realTime = new DateTime.fromMicrosecondsSinceEpoch(t*1000 , 
            isUtc: true);

          var date = dateFormat.format(realTime);
          //var time = timeFormat.format(realTime);

          //int tn = DateTime.now().toUtc().millisecondsSinceEpoch;

          // Image.network(
          //   'http://openweathermap.org/img/w/$icon.png',
          //   height: height,
          //   width:  width,
          //   );
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //time
              Text("${date.toString()}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              SizedBox(height: 10,),

              //icon
              Image.network('http://openweathermap.org/img/w/$icon.png'),

              //SizedBox(height: 10,),

              //humidity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.invert_colors, color: Colors.grey[100],),
                  SizedBox(width: 8),
                  Text("$humidity %",
                    style: TextStyle(color: Colors.grey[100]),
                  ),
                ],
              ),

              SizedBox(height: 25,),

              //tempertature max
              Text("$tempmin°",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),

              SizedBox(height: 15,),

              //tempertature min
              Text("$tempmax°",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),

            ],
          );
         
        }
        else
        {
          return Text("...",
            style: TextStyle(color: Colors.white, fontSize: 25),
          );
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

      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     showWeather();
      //   },
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
                                    //_showAlertMessage
                                    _citySearchController.clear();
                                    //showWeather();
                                      print("Searching ....");
                                      
                                      setState(() {
                                        updatePlaceNameWidget("${city == null ? util.defaultCity : city}");
                                        updateDateAndTimeNow(dateNow, timeNow);
                                        updateDataTempWidget("${city == null ? util.defaultCity : city}");
                                        updateIconTempWidget("${city == null ? util.defaultCity : city}", (((mesure/4)*2)/4)*3.5, (((size.shortestSide/4)*3)/5)*2);
                                        updateMinMaxTempWidget("${city == null ? util.defaultCity : city}");
                                        updateTempRessentieWidget("${city == null ? util.defaultCity : city}");
                                        updateDescriptionTempWidget("${city == null ? util.defaultCity : city}");
                                        //updateHoursDayTempWidget("$city",0);
                                        updateCloudWidget("${city == null ? util.defaultCity : city}");
                                        updateHumidityWidget("${city == null ? util.defaultCity : city}");
                                        updateWindSpeedWidget("${city == null ? util.defaultCity : city}");
                                        updateWindDirectionWidget("${city == null ? util.defaultCity : city}");
                                        updatePressureWidget("${city == null ? util.defaultCity : city}");
                                        updateVisibilityWidget("${city == null ? util.defaultCity : city}");
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

                        //Description
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

            //Detail essentiels Clouds Humidite
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure/2,
                width: size.shortestSide,
                //color: Colors.grey,
                child: Center(
                  child:ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children:<Widget> [

                      //Clouds %
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.cloud, color: Colors.white,)),
                              ),

                              //Clouds
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Clouds",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updateCloudWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      
                      //Humidity
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.invert_colors, color: Colors.white,)),
                              ),

                              //Humidity
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Humidity",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updateHumidityWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),




                            ],
                          ),
                        ),
                      ),


                    ],
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
                        child: titleText("Weather Tomorrow"),
                      ),
                    ),

                    //Horaires
                    Container(
                      height: (mesure*1.125) - (mesure/5),
                      width: size.shortestSide,
                      //color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0,5,0,5),
                        
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7, 
                          itemBuilder: (BuildContext context, int position){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: (mesure*1.125) - (mesure/5),
                                width: (size.shortestSide)/4,
                                //color: Colors.red,
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(18.0), 
                                  border: Border.all(color: Colors.grey[300] , width: 2)
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    updateWeatherTomorrowWidget("$city", position)
                                  ],
                                )

                              ),
                            );
                          }
                          ),
                
                         
                      ),

                    ),
                    

                  ],
                )
              ),
            ),

            myDivider(15,15),

            // 5Days
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure*(1.5),
                width: size.shortestSide,
                //color: Colors.red,
                child: Column(
                  children: <Widget>[
                    
                    //Text Quotidien
                    Container(
                      height: mesure/5,
                      width: size.shortestSide,
                      //color: Colors.grey,
                      child: Center(
                        child: titleText("This week"),
                      ),
                    ),

                    //Horaires
                    Container(
                      height: (mesure*1.5) - (mesure/5),
                      width: size.shortestSide,
                      //color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int position){

                            var lst = new List(5); 
                            lst[0] = 4; 
                            lst[1] = 12; 
                            lst[2] = 20;
                            lst[3] = 28;
                            lst[4] = 37;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: (mesure*1.5) - (mesure/5),
                                width: (size.shortestSide)/4,
                                //color: Colors.red,
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(18.0), 
                                  border: Border.all(color: Colors.grey[300] , width: 2)
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    update5DaysWeatherWidget("$city",lst[position])
                                    
                                  ],
                                )

                              ),
                            );

                          },
                          
                        ),
                         
                      ),

                    ),
                    

                  ],
                )
              ),
            ),


            myDivider(15,15),

           //Details zyada
            ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: Container(
                height: mesure*1.25,
                width: size.shortestSide,
                //color: Colors.grey,
                child: Center(
                  child:ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children:<Widget> [


                      //More Details text
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: titleText("More details")
                        ),
                      ),

                      //Wind speed
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.speed, color: Colors.white,)),
                              ),

                              //Wind speed
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Wind speed",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updateWindSpeedWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),




                            ],
                          ),
                        ),
                      ),

                      //Wind direction
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.show_chart, color: Colors.white,)),
                              ),

                              //Wind direction
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Wind direction",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updateWindDirectionWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      //Pressure
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.shutter_speed, color: Colors.white,)),
                              ),

                              //Pressure
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Pressure",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updatePressureWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    
                      //Visibility
                      Container(
                        height: mesure/4,
                        width: size.shortestSide,
                        //color: Colors.red[400],
                        child: Center(
                          child: Row(
                            children: [
                              
                              //Icon
                              Container(
                                height: mesure/4,
                                width: size.shortestSide/6,
                                //color: Colors.pinkAccent,
                                child: Center(child: Icon(Icons.remove_red_eye, color: Colors.white,)),
                              ),

                              //Humidity
                              Container(
                                height: mesure/4,
                                width: (size.shortestSide/6)*5,
                                //color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Text("Visibility",
                                          style: TextStyle(color: Colors.white, fontSize: 16 ),
                                      ),

                                      updateVisibilityWidget("$city")
                                      
                                    ],
                                  ),
                                ),
                              ),




                            ],
                          ),
                        ),
                      ),

                    
                    ],
                  ),
               
                ),
              ),
            ),
           
           Divider(
              color: Colors.white,
              thickness: 0.5,
              indent: size.shortestSide/4,
              endIndent: size.shortestSide/4,
            )
            


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
              indent: 15,
              endIndent: 15,
            );
  }

  Widget titleText(String text)
  {
    return Text(
      "$text",
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        //fontWeight: FontWeight.w100
      ),
    );
  }

//   void _showAlertMessage(BuildContext context, String alertMessage)
// {
//   var alert = new AlertDialog(
//     title: new Text("Alert Dialog"),
//     content: new Text(alertMessage),
//     actions: <Widget>[
//       new FlatButton(
//         onPressed: () {Navigator.pop(context);},  
//         child: new Text("OK"),
//         ),
//     ],
//   );

//   showDialog(context: context, builder: (context) => alert );

// }

 