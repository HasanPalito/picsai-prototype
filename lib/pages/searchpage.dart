import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchPageModel extends FlutterFlowModel<SearchPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class SearchPageWidget extends StatefulWidget {

  final dynamic name;
  final dynamic gmail;
  final dynamic pic_url;
  final dynamic JWT_TOKEN;

  const SearchPageWidget({super.key,required this.name,required this.gmail,required this.pic_url,required this.JWT_TOKEN});

  @override
  State<SearchPageWidget> createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late SearchPageModel _model;
  double? USAGE;
  String? encryption_key;
  Map<String, String> objectlist={};
  List<MapEntry<String, String>> imageEntries=[];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> get_User_usage() async {
    print(widget.JWT_TOKEN);
    final response = await http.get(
      Uri.parse('https://elastic-surf-08465.pktriot.net/usage'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.JWT_TOKEN}'
      }
    );
    if (response.statusCode == 200) {
      var respn =jsonDecode(response.body);
      setState(() {
        USAGE = respn["usage"];
      });
    }
  }

  Future<String?> getEncryptionKey() async {
    var key= await secureStorage.read(key: 'encryption_key');
    setState(() {
      encryption_key = key;
    });
    return key;
  }

  Future<void> get_start_file() async {
    print(widget.JWT_TOKEN);
    print("FETCHING IMAGE LIST");
    String? encryptionKey = await getEncryptionKey();
    final data = 'user_key=${Uri.encodeQueryComponent(encryptionKey!)}&n=10';
    final response = await http.post(
        Uri.parse('https://elastic-surf-08465.pktriot.net/startfile'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${widget.JWT_TOKEN}'
        }
        ,body: data

    );
    print(response.body);
    print("THIS IS THE IMAGE LIST");
    if (response.statusCode == 200) {
      var respn =jsonDecode(response.body);
      setState(() {
        objectlist=respn;
        imageEntries = objectlist.entries.toList();
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    // Run your asynchronous functions here

    await get_User_usage();
    print("get_User_usage() completed");
    await getEncryptionKey();
    print("get encryption key completed");
    await get_start_file();
    print("get encryption key completed");
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
        appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(MediaQuery.sizeOf(context).height * 0.075),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).height * 0.075,
              decoration: BoxDecoration(
                color: Color(0xB4F9F9F9),
                borderRadius: BorderRadius.circular(10.0),
                shape: BoxShape.rectangle,
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: AutoSizeText(
                    '${widget.name}',
                    minFontSize: 15.0,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Inter Tight',
                      color: Color(0xFF1023FF),
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).width * 0.1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.1,
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.1,
                          height: MediaQuery.sizeOf(context).width * 0.1,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            '${widget.pic_url}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        CircularPercentIndicator(
                          percent: USAGE ?? 0.0,
                          radius: MediaQuery.sizeOf(context).width * 0.05,
                          lineWidth: 4.0,
                          animation: true,
                          animateFromLastPercent: true,
                          progressColor: FlutterFlowTheme.of(context).primary,
                          backgroundColor: FlutterFlowTheme.of(context).accent4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://fastly.picsum.photos/id/115/600/600.jpg?hmac=AcUMZvhEyHEKnXlmFL_vvfQCle13G4RZE9jQGNtRuKM',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            centerTitle: false,
            elevation: 10.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.08,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          textInputAction: TextInputAction.send,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            hintText: 'TextField',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          style:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                          textAlign: TextAlign.start,
                          maxLength: 100,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          buildCounter: (context,
                              {required currentLength,
                                required isFocused,
                                maxLength}) =>
                          null,
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: '',
                          icon: Icon(
                            Icons.search_sharp,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            width: MediaQuery.sizeOf(context).width * 0.1,
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsets.all(0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
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
              Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                  child: MasonryGridView.builder(
                    gridDelegate:
                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    itemCount:  imageEntries.length,
                    itemBuilder: (context, index) {
                      final key = imageEntries[index].key; // e.g., "image1"
                      final url = imageEntries[index].value;
                      return GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tapped on $key')),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            url,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );// e.g., the URL
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

