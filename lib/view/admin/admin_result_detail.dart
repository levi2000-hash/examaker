import 'package:examaker/model/examen.dart';
import 'package:examaker/model/examenMoment.dart';
import 'package:examaker/singleton/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:uuid/uuid.dart';

class ResultPageDetail extends StatefulWidget {
  const ResultPageDetail({Key? key}) : super(key: key);
  @override
  State<ResultPageDetail> createState() => _ResultPageDetailState();
}

class _ResultPageDetailState extends State<ResultPageDetail> {
  ExamenMoment moment = appData.currentMoment!;
  Examen examen = appData.currentExam!;
  late MapController mapController =
      MapController(initMapWithUserPosition: true, initPosition: null);

  @override
  void initState() {
    super.initState();
    // mapController.osmBaseController
    //     .addMarker(GeoPoint(latitude: moment.lat, longitude: moment.lon));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${moment.student!.name} (${examen.naam})"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: moment.antwoorden!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(
                          "${(moment.antwoorden![index]["vraag"])}: ${(moment.antwoorden![index]["antwoord"])}")),
                );
              }),
          Text("Focus verloren: ${moment.outOfFocusCount}"),
          Text("Adres: ${moment.adres}"),
          Flexible(
            child: OSMFlutter(
                controller: mapController,
                initZoom: 16,
                userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(Icons.location_history_rounded,
                          color: Colors.red, size: 48),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(Icons.double_arrow, size: 48),
                    ))),
          )
        ],
      ),
    );
  }
}
