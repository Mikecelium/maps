
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';




//STYLE INFO

class StyleInfo {
  final String name;
  final String baseStyle;
  final Future<void> Function(MapboxMapController) addDetails;
  final CameraPosition position;

  const StyleInfo(
      {required this.name,
      required this.baseStyle,
      required this.addDetails,
      required this.position});
}









class Sources extends ExamplePage {
  Sources() : super(const Icon(Icons.map), 'Various Sources');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}










class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}









class FullMapState extends State<FullMap> {
  MapboxMapController? controller;
  final watercolorRasterId = "watercolorRaster";
  int selectedStyleId = 0;

  _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    addGeojsonHeatmap(controller);
    addGeojsonHeatmap2(controller);

  }

 








  static Future<void> addGeojsonHeatmap(MapboxMapController controller) async {
    await controller.addSource(
        "earthquakes-heatmap-source",
        GeojsonSourceProperties(
          data:
          "assets/data.geojson"
              //'https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson',
        ));
    await controller.addLayer(
        "earthquakes-heatmap-source",
        "earthquakes-heatmap-layer",
        HeatmapLayerProperties(
          heatmapColor: [
            Expressions.interpolate,
            ["linear"],
            ["heatmap-density"],
            0,
            "rgba(33.0, 102.0, 172.0, 0.0)",
            0.2,
            "rgb(103.0, 169.0, 207.0)",
            0.4,
            "rgb(209.0, 229.0, 240.0)",
            0.6,
            "rgb(253.0, 219.0, 240.0)",
            0.8,
            "rgb(239.0, 138.0, 98.0)",
            1,
            "rgb(178.0, 24.0, 43.0)",
          ],
          heatmapWeight: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.get, "mag"],
            0,
            0,
            6,
            1,
          ],
          heatmapIntensity: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            0,
            1,
            9,
            3,
          ],
          heatmapRadius: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            0,
            2,
            9,
            20,
          ],
          heatmapOpacity: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            7,
            1,
            9,
            0.1
          ],
        ));

  }



        static Future<void> addGeojsonHeatmap2(MapboxMapController controller) async {
    await controller.addSource(
        "earthquakes-heatmap-source2",
        GeojsonSourceProperties(
          data:
          "assets/data.geojson"
              //'https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson',
        ));
    await controller.addLayer(
        "earthquakes-heatmap-source2",
        "earthquakes-heatmap-layer2",
        HeatmapLayerProperties(
          heatmapColor: [
            Expressions.interpolate,
            ["linear"],
            ["heatmap-density"],
            0,
            "rgba(33.0, 102.0, 172.0, 0.0)",
            0.2,
            "rgb(20.0, 50.0, 207.0)",
            0.4,
            "rgb(209.0, 100.0, 240.0)",
            0.6,
            "rgb(253.0, 5.0, 240.0)",
            0.8,
            "rgb(239.0, 208.0, 98.0)",
            1,
            "rgb(178.0, 24.0, 43.0)",
          ],
          heatmapWeight: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.get, "mag"],
            0,
            0,
            6,
            1,
          ],
          heatmapIntensity: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            0,
            1,
            9,
            3,
          ],
          heatmapRadius: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            0,
            2,
            9,
            20,
          ],
          heatmapOpacity: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            7,
            1,
            9,
            0.1
          ],
        ));

    
    



  }

  static Future<void> addVector(MapboxMapController controller) async {
    await controller.addSource(
        "terrain",
        VectorSourceProperties(
          url: "mapbox://mapbox.mapbox-terrain-v2",
        ));

    await controller.addLayer(
        "terrain",
        "contour",
        LineLayerProperties(
          lineColor: "#ff69b4",
          lineWidth: 1,
          lineCap: "round",
          lineJoin: "round",
        ),
        sourceLayer: "contour");
  }







  static const _stylesAndLoaders = [
    
    
 
    StyleInfo(
      name: "Geojson heatmap",
      baseStyle: MapboxStyles.DARK,
      addDetails: addGeojsonHeatmap,
      position: CameraPosition(target: LatLng(33.5, -118.1), zoom: 5),
    ),
    
  
    
  
  ];









  _onStyleLoadedCallback() async {
    final styleInfo = _stylesAndLoaders[selectedStyleId];
    styleInfo.addDetails(controller!);
    controller!
        .animateCamera(CameraUpdate.newCameraPosition(styleInfo.position));
  }









  @override
  Widget build(BuildContext context) {
    final styleInfo = _stylesAndLoaders[selectedStyleId];
    final nextName =
        _stylesAndLoaders[(selectedStyleId + 1) % _stylesAndLoaders.length]
            .name;
    return new Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton.extended(
            icon: Icon(Icons.swap_horiz),
            label: SizedBox(
                width: 120, child: Center(child: Text("To $nextName"))),
            onPressed: () => setState(
              () => selectedStyleId =
                  (selectedStyleId + 1) % _stylesAndLoaders.length,
            ),
          ),
        ),
        body: Stack(
          children: [
            MapboxMap(
              styleString: styleInfo.baseStyle,
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              initialCameraPosition: styleInfo.position,
              onStyleLoadedCallback: _onStyleLoadedCallback,
            ),
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current source ${styleInfo.name}",
                    textScaleFactor: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
