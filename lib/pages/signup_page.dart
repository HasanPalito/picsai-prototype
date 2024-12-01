import 'dart:convert';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'searchpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: FlutterFlowWebView(
            content: 'https://sharp-meadow-14440.pktriot.net/login',
            bypass: false,
            height: 500.0,
            verticalScroll: false,
            horizontalScroll: false,
          )
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class TestModel extends FlutterFlowModel<TestWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late TestModel _model;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:"495043862553-0mgs5p9uiutd5e2d6jou1j9553ricr4i.apps.googleusercontent.com",
    scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
  );
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleSignInAccount? _currentUser;
  String? JWT_token;
  String? ENCRYPTION_KEY;

  Future<void> saveEncryptionKey(String key) async {
    await secureStorage.write(key: 'encryption_key', value: key);
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleAuth = await _googleSignIn.currentUser?.authentication;
      String? idToken = googleAuth?.idToken;
      print(idToken);
      if (idToken != null) {
        print("uhmwhatdasigma");
        await sendTokenToBackend(idToken);  // Send token to backend
      }
      String photoUrl = _currentUser?.photoUrl ?? 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fno-profile&psig=AOvVaw3lZsLXlLGUjPe_yObukal3&ust=1728397716600000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCPiDkbO9_IgDFQAAAAAdAAAAABAE';
      print('Signed in user: ${_currentUser?.displayName}, Email: ${_currentUser?.email}, URl : ${photoUrl}');
    } catch (error) {
      print('Sign in failed: $error');
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
  }

  Future<void> sendTokenToBackend(String idToken) async {
    final data = {
      'token_data': idToken,
    };
    final url = Uri.parse('https://elastic-surf-08465.pktriot.net/auth/google');
    // Send the idToken to FastAPI
    final response = await http.post(
      Uri.parse('https://elastic-surf-08465.pktriot.net/auth/google'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token_data': idToken,
      },
    );
    if (response.statusCode == 200) {
      print("Token sent successfully.");
      var resp =jsonDecode(response.body);
      setState(() {
        JWT_token =resp["access_token"];
        print(JWT_token);
      });
      try{
        final create_user = await http.post(
          Uri.parse('https://elastic-surf-08465.pktriot.net/create_user'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $JWT_token'
          },
        );
        if (create_user.statusCode == 200) {
          try{
            var respn =jsonDecode(create_user.body);
            setState(() {
              ENCRYPTION_KEY = respn["key"];
              print(ENCRYPTION_KEY);
              saveEncryptionKey(ENCRYPTION_KEY!);
            });

          }
          catch(e){
              print(e);
          }
        }
      }
      catch(e){
        print(e);
      }


    } else {
      print("Failed to send token: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestModel());
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
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


        //backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5ABAB),
          automaticallyImplyLeading: false,
          title: Text(
            'PicsAi Prototype\n',

          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await _handleSignIn();
                      if (_currentUser != null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPageWidget(JWT_TOKEN: JWT_token,name:_currentUser?.displayName,gmail: _currentUser?.email,pic_url:_currentUser?.photoUrl ?? 'https://img.freepik.com/premium-vector/user-customer-avatar-vector-illustration_276184-160.jpg',)),
                        );
                      }

                    },
                    text: _currentUser != null && _currentUser!.displayName != null
                        ? "Sign In as ${_currentUser!.displayName}"
                        : "Sign In with Google",
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFF5ABAB),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: FFButtonWidget(
                    onPressed: (){
                      _handleSignOut();
                    },
                    text: 'Sign out',
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFF5ABAB),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
