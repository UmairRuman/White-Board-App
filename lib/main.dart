import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rest_countries_api_implementation/api_services.dart';
import 'package:rest_countries_api_implementation/countryMetaData_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountryApiService countryApiService = CountryApiService();
  TextEditingController? textEditingController;

  int _counter = 0;
  Future<List<Autogenerated>>? future;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  void _incrementCounter() {
    setState(() {
      try {
        _counter++;
        future = countryApiService.fetchCountriesData("/india");
      } catch (e) {
        log('[Error : ${e.toString()}]');
      }
    });
  }

  void onClickOnIcon() {
    setState(() {
      future = countryApiService
          .fetchCountriesData("/${textEditingController!.text}");
    });
  }

  @override
  void dispose() {
    textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 500,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(

                      // fillColor: Colors.brown.shade200,
                      // filled: true,
                      label: Text(
                        "Enter Country name",
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.white,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(25)))),
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    color: Colors.black,
                    onPressed: onClickOnIcon,
                    icon: const Icon(Icons.done_outline_outlined)),
              )
            ],
          ),
          Container(
            width: 400,
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(5, 5),
                      spreadRadius: 5,
                      blurRadius: 10)
                ]),
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Text("Enter the country name to fetch its data");
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.network(snapshot.data![0].flags!.png!)),
                      Text("SubRegion : ${snapshot.data![0].subregion} "),
                      Text("Region : ${snapshot.data![0].region}"),
                      Text("Population : ${snapshot.data![0].population} "),
                      Text("Capital : ${snapshot.data![0].capital![0]}"),
                      Text("Timezone : ${snapshot.data![0].timezones![0]}"),
                      Text("Continent : ${snapshot.data![0].continents![0]}"),
                    ],
                  );
                }
                return const Text("No data Found");
              },
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
