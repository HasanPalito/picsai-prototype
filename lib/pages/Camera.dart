import 'flutter_flow_theme.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as base;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
class CameraModel extends FlutterFlowModel<CameraWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class CameraWidget extends StatefulWidget {
  final dynamic JWT_TOKEN;

  const CameraWidget({super.key,required this.JWT_TOKEN});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraModel _model;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  XFile? capturedImage;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String encryption_key="";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> showAlertDialog(BuildContext context, String title) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Captured Image',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: 'Inter Tight',
              color: Color(0xFFB739B7),
              letterSpacing: 0.0,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Image(image: FileImage(File(capturedImage!.path)),fit: BoxFit.cover),
            )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: MediaQuery.sizeOf(context).width * 0.15,
                    fillColor: Color(0xFFB739B7),
                    icon: Icon(
                      Icons.cancel,
                      color: FlutterFlowTheme.of(context).info,
                      size: 35.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      // Call your async function
                      await Upload_file(capturedImage!);
                      Navigator.pop(context);
                    },
                    text: '',
                    icon: Icon(
                      Icons.send_sharp,
                      size: 30.0,
                    ),
                    showLoadingIndicator: true, // This will show a loading indicator while the async task runs
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.15,
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                      iconPadding: EdgeInsets.all(0.0),
                      color: Color(0xFFB739B7),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(width: 45.0)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile image = await _cameraController!.takePicture();
        setState(() {
          capturedImage = image;
        });
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  Future<void> _initializeCamera() async {
    // Fetch the available cameras
    cameras = await availableCameras();

    // Initialize the first available camera
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      // Update the state after initializing the camera
      setState(() {});
    }
  }
  Future<String?> getEncryptionKey() async {
    print("called in init state");
    var key= await secureStorage.read(key: 'encryption_key');
    setState(() {
      encryption_key = key!;
    });
    return key;
  }

  Future<void> Upload_file(XFile file) async {
    print("UPLOADING");
    var client = http.Client();
    print(encryption_key);
    print("SIGMA SIGMA");
    print("${widget.JWT_TOKEN}");
    final url = Uri.parse('https://elastic-surf-08465.pktriot.net/uploadfile');
    final req = http.MultipartRequest('POST', url)
      ..fields['user_key'] = encryption_key;
    req.headers['Authorization'] = 'Bearer ${widget.JWT_TOKEN}';
    req.headers['Content-Type'] = 'multipart/form-data';

    req.files.add(
      http.MultipartFile(
        'file', // Field name
        file.openRead(), // Stream for file contents
        await file.length(), // File length
        filename: base.basename(file.path), // File name
        contentType: MediaType('application', 'octet-stream'), // MIME type
      ),
    );

    final stream = await req.send();
    final res = await http.Response.fromStream(stream);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.send error: statusCode= $status');
    else();

  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    getEncryptionKey();
    _model = createModel(context, () => CameraModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: '',
                        icon: FaIcon(
                          FontAwesomeIcons.times,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 36.0,
                        ),
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: '[4:3]',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                            fontFamily: 'Inter Tight',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: '',
                        icon: Icon(
                          Icons.flash_off_sharp,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 36.0,
                        ),
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: '',
                        icon: Icon(
                          Icons.camera_enhance_outlined,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 36.0,
                        ),
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75, // 85% of screen height
                        child:_cameraController != null && _cameraController!.value.isInitialized
                          ? CameraPreview(_cameraController!)
                          : Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'Initializing Camera...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async{
                              await _captureImage();
                              showAlertDialog(context,"captured image");
                            },
                            text: '',
                            icon: Icon(
                              Icons.brightness_1_outlined,
                              color: Color(0xFFD52CDC),
                              size: 50.0,
                            ),
                            options: FFButtonOptions(
                              width: MediaQuery.sizeOf(context).width * 0.254,
                              height: MediaQuery.sizeOf(context).height * 0.091,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsets.all(0.0),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
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
    );
  }
}

