import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_example/animate_camera.dart';
import 'package:mapbox_example/annotation_order_maps.dart';
import 'package:mapbox_example/custom_marker.dart';
import 'package:mapbox_example/example_page.dart';
import 'package:mapbox_example/full_map.dart';
import 'package:mapbox_example/line.dart';
import 'package:mapbox_example/local_style.dart';
import 'package:mapbox_example/map_ui.dart';
import 'package:mapbox_example/move_camera.dart';
import 'package:mapbox_example/offline_regions.dart';
import 'package:mapbox_example/place_batch.dart';
import 'package:mapbox_example/place_circle.dart';
import 'package:mapbox_example/place_fill.dart';
import 'package:mapbox_example/place_source.dart';
import 'package:mapbox_example/place_symbol.dart';
import 'package:mapbox_example/scrolling_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MapsDemo(),
    );
  }
}

class MapsDemo extends StatefulWidget {
  @override
  _MapsDemoState createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {

  late LocationPermission permission;

  final List<ExamplePage> _allPages = <ExamplePage>[
    FullMapPage(),
    MapUiPage(),
    AnimateCameraPage(),
    MoveCameraPage(),
    PlaceSymbolPage(),
    PlaceSourcePage(),
    LinePage(),
    LocalStylePage(),
    PlaceCirclePage(),
    PlaceFillPage(),
    ScrollingMapPage(),
    OfflineRegionsPage(),
    AnnotationOrderPage(),
    CustomMarkerPage(),
    BatchAddPage()
  ];

  // void _pushPage(BuildContext context, ExamplePage page) async {
  //   if (!kIsWeb) {
  //     final location = Location();
  //     final hasPermissions = await location.hasPermission();
  //     if (hasPermissions != PermissionStatus.granted) {
  //       await location.requestPermission();
  //     }
  //   }
  //   Navigator.of(context).push(MaterialPageRoute<void>(
  //       builder: (_) => Scaffold(
  //         appBar: AppBar(title: Text(page.title)),
  //         body: page,
  //       )));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestPermission();
  }

  void requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    this.permission = permission;
  }

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (permission == LocationPermission.denied) {
      requestPermission();
    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(page.title)),
            body: page,
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}
