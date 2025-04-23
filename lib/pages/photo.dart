import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PhotoModel extends FlutterFlowModel<PhotoWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class PhotoWidget extends StatefulWidget {
  final dynamic filename;
  final dynamic pic_url;
  final dynamic description;
  const PhotoWidget({super.key,required this.filename,required this.pic_url,this.description = "Try searching"});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  late PhotoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PhotoModel());
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
            },
          ),
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Text(
                  '29 Oktober 2024',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Inter Tight',
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Text(
                  '16:15 WIB',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 8.0),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                borderWidth: 1.0,
                buttonSize: MediaQuery.sizeOf(context).width * 0.1,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                      child: Image.network(
                        widget.pic_url,
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 340.0,
                        fit: BoxFit.cover,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          valueOrDefault<double>(
                            MediaQuery.sizeOf(context).width >= 1270.0
                                ? 24.0
                                : 0.0,
                            0.0,
                          ),
                          0.0,
                          0.0),
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 0.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        runAlignment: WrapAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxWidth: 570.0,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0.0,
                                      1.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 12.0, 16.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.filename,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                              fontFamily: 'Inter Tight',
                                              color: Color(0xFFD52CDC),
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                          Text(
                                            widget.description,
                                            textAlign: TextAlign.justify,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () {
                                                  print('Button pressed ...');
                                                },
                                                text: '',
                                                icon: Icon(
                                                  Icons.favorite_border,
                                                  color: Color(0xFFD52CDC),
                                                  size: 27.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(0.0, 0.0,
                                                      0.0, 0.0),
                                                  color: Color(0x004B39EF),
                                                  textStyle:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .headlineSmall
                                                      .override(
                                                    fontFamily:
                                                    'Inter Tight',
                                                    fontSize: 0.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0.0,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      0.0),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () {
                                                  print('Button pressed ...');
                                                },
                                                text: '',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color: Color(0xFFD52CDC),
                                                  size: 27.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(0.0, 0.0,
                                                      0.0, 0.0),
                                                  color: Color(0x004B39EF),
                                                  textStyle:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .titleSmall
                                                      .override(
                                                    fontFamily:
                                                    'Inter Tight',
                                                    color: Colors.white,
                                                    fontSize: 0.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      0.0),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () {
                                                  print('Button pressed ...');
                                                },
                                                text: '',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.edit,
                                                  color: Color(0xFFD52CDC),
                                                  size: 27.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(0.0, 0.0,
                                                      0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                      context)
                                                      .primary,
                                                  textStyle:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .titleSmall
                                                      .override(
                                                    fontFamily:
                                                    'Inter Tight',
                                                    color: Colors.white,
                                                    fontSize: 0.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8.0),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () {
                                                  print('Button pressed ...');
                                                },
                                                text: '',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.lock,
                                                  color: Color(0xFFD52CDC),
                                                  size: 27.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(0.0, 0.0,
                                                      0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                      context)
                                                      .primary,
                                                  textStyle:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .titleSmall
                                                      .override(
                                                    fontFamily:
                                                    'Inter Tight',
                                                    color: Colors.white,
                                                    fontSize: 0.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8.0),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 30.0)),
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 500.0,
                            ),
                            decoration: BoxDecoration(),
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
      ),
    );
  }
}

