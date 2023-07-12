import 'dart:convert';

import 'package:assignment_9/weather_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  WeatherData? weatherData ;
  bool inProgress = false;

  String convertTimeStampToHumanHour(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat('h:mm a', 'en_US').format(dateToTimeStamp);
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();

  }

  void getWeatherData() async{
    inProgress= true;
    setState(() {
    });

    Response response = await get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=23.8479&lon=90.2576&units=metric&appid=4689fa9df54e2aef5b7c53b5482fe63b"));
    if(response.statusCode == 200 ){
      final map = json.decode(response.body);
      weatherData = WeatherData.fromJson(map);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
          backgroundColor: Colors.cyan,
          content: Text(
              'Failed to load weather data',
              style:  TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold))));
    }

    inProgress = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade900, Colors.purple.shade800]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title:  const Text(
            "Flutter Weather",),
          centerTitle: false,
          elevation: 5,
          actions: [
            IconButton(
                onPressed: (){
                  getWeatherData();
                  setState(() {});

                }, icon: const Icon(Icons.settings)
            ),
            IconButton(
                onPressed: (){

                }, icon: const Icon(Icons.add)
            ),
          ],
          backgroundColor: const Color(0x6E1081FF),
        ),
        body: inProgress? const Center(
          child: CircularProgressIndicator(
            backgroundColor: Color(0xcfcf5b65),
            strokeWidth: 5,
            color: Colors.white,
          ),
        ): Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${weatherData?.name}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                  "Updated:${convertTimeStampToHumanHour(weatherData?.dt?.toInt() ?? 0)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal
                  )
              ),
              Text(
                  "${weatherData?.weather?[0].description}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text(
                        "${weatherData?.main?.temp?.round()}\u00B0",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        )
                    ),

                    Column(
                      children: [
                        Text(
                            "max: ${weatherData?.main?.tempMax}\u00B0",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal
                            )
                        ),
                        Text(
                            "min: ${weatherData?.main?.tempMin}\u00B0",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal
                            )
                        ),
                        Image.network(
                          "https://openweathermap.org/img/wn/${weatherData?.clouds}@2x.png",width: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image,weight: 60,);
                          },
                        )
                      ],
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }


}