import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Camera.dart';
import 'package:image_picker/image_picker.dart';



class UploadimageModel extends FlutterFlowModel<UploadimageWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class UploadimageWidget extends StatefulWidget {
  final dynamic JWT_TOKEN;
  const UploadimageWidget({super.key,required this.JWT_TOKEN});


  @override
  State<UploadimageWidget> createState() => _UploadimageWidgetState();
}

class _UploadimageWidgetState extends State<UploadimageWidget> {
  late UploadimageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadimageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera for camera

    if (image != null) {
      // Do something with the image (e.g., display it or upload)
      print("Picked image path: ${image.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          bottomNavigationBar:BottomNavigationBar(
              currentIndex: 1, // Highlight the selected tab
              onTap: (index) {
                setState(() {
                  print(index);
                });
                if (index==0){
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "upload",
                ),
              ]),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                onTap: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraWidget(JWT_TOKEN: widget.JWT_TOKEN))

                  )
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0x00FFFFFF),
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: Color(0xFFB739B7),
                      width: 3.0,
                    ),
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(0xFFB739B7),
                          size: 100.0,
                        ),
                      ),
                      Text(
                        'Take Picture',
                        style:
                        FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Inter Tight',
                          color: Color(0xFFB739B7),
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                )),
              GestureDetector(
                  onTap: ()=>{
                    _pickImage()
                  },
                  child:Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0x00FFFFFF),
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: Color(0xFFB739B7),
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        color: Color(0xFFB739B7),
                        size: 100.0,
                      ),
                      Text(
                        'Upload From Gallery',
                        style:
                        FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Inter Tight',
                          color: Color(0xFFB739B7),
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                )),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        ),
      ),
    );
  }
}
