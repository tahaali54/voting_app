import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  final Color _primaryColor = Color(0xFF00c853);
  final Color _secondaryColor = Color(0xFF1b5e20);
  final Color _accentColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: ThemeData(
        backgroundColor: _secondaryColor,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        buttonColor: _primaryColor,
        unselectedWidgetColor: _accentColor,
      ),
      home: MainPage(
        title: 'ELECTIONS 2019',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;
  //final List<String> _allActivities = <String>['PTI', 'PMLN', 'MQM', 'TLP', 'PSP', 'PPP', 'PAT', 'ANP', 'JUI', ];
  //String _activity = 'PTI';
  int _naRadioGroupValue = -1;
  bool naVoteCasted = false;
  bool paVoteCasted = false;
  bool votingComplete = false;

  void _handleRadioValueChange1(int value) {
    if (!naVoteCasted) {
      setState(() {
        _naRadioGroupValue = value;
      });
    }
  }

  void _handleRadioValueChange2(int value) {
    if (!paVoteCasted) {
      setState(() {
        _naRadioGroupValue = value;
      });
    }
  }

  @override
  void initState() {
    controller = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      Track("PPP", 250),
      Track("PTI", 1250),
      Track("PMLN", 450),
      Track("TLP", 650),
    ];
    final provincial_data = [
      Provincial('Sindh', 75, 'PPP'),
      Provincial('Punjab', 100, 'PMLN'),
      Provincial('Balochistan', 55, 'TLP'),
      Provincial('KPK', 25, 'PTI'),
    ];
    final provincial_series = [
      charts.Series<Provincial, String>(
        id: 'provincialChart',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Provincial winner, _) => winner.province,
        measureFn: (Provincial winner, _) => winner.votes,
        data: provincial_data,
        labelAccessorFn: (Provincial winner, _) => winner.party,
      ),
    ];
    var series = [
      charts.Series(
          domainFn: (Track track, _) => track.day,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          measureFn: (Track track, _) => track.steps,
          id: 'nationalChart',
          data: data)
    ];

    var barChart = charts.BarChart(
      provincial_series,
      animate: false,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );

    var pieChart = charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 30,
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(92.0),
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              Text(
                'SATURDAY, MARCH 16TH',
                style: TextStyle(color: Theme.of(context).backgroundColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  '${DateTime(2019, 03, 16).difference(DateTime.now()).inHours} Hours Away',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageIndicator(
                  layout: PageIndicatorLayout.WARM,
                  size: 8.0,
                  controller: controller,
                  space: 4.0,
                  count: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: controller,
        children: [
          //Start of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //


          //Not working
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('polls').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                DocumentSnapshot first = snapshot.data.documents.first;
                var pollArray = first['pollOptions'];

                return ListView(
                  padding: const EdgeInsets.only(top: 20.0),
                  children: pollArray
                      .map((data) => _buildListItem(context, data, 0))
                      .toList(),
                );
              },
            ),
          ),


          Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'NATIONAL ASSEMBLY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                new RadioListItem(
                  flag:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Flag_of_the_Pakistan_Tehreek-e-Insaf.svg/324px-Flag_of_the_Pakistan_Tehreek-e-Insaf.svg.png',
                  radioValue1: _naRadioGroupValue,
                  fullName: 'Flutter Tehreek-e-Insaaf',
                  index: 0,
                  initials: 'FTI',
                  onChanged: _handleRadioValueChange1,
                ),
                ListTile(
                  leading: Radio(
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Tahrek-e-Labaik Pakistan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'TLP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Muslim League',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PMLN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 3,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan People Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PPP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 4,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Awami National Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'ANP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 8),
                  child: RaisedButton(
                    onPressed: naVoteCasted
                        ? null
                        : () {
                            if (_naRadioGroupValue == -1) {
                              showAlertDialog(context, 'Unable to proceed',
                                  'Please select a party to vote.');
                            } else {
                              setState(() {
                                naVoteCasted = true;
                              });
                              controller.jumpToPage(1);
                            }
                          },
                    shape: Border.all(
                      color: naVoteCasted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).accentColor,
                    ),
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: naVoteCasted
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Theme.of(context).backgroundColor,
          ),

          //End of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'PROVINCIAL ASSEMBLY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                ListTile(
                  leading: Radio(
                    value: 0,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange2,
                  ),
                  title: Text(
                    'Pakistan Tahrek-e-Insaf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PTI',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange2,
                  ),
                  title: Text(
                    'Tahrek-e-Labaik Pakistan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'TLP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange2,
                  ),
                  title: Text(
                    'Pakistan Muslim League',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PMLN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 3,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange2,
                  ),
                  title: Text(
                    'Pakistan People Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PPP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 4,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _naRadioGroupValue,
                    onChanged: _handleRadioValueChange2,
                  ),
                  title: Text(
                    'Awami National Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'ANP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 8),
                  child: RaisedButton(
                    onPressed: paVoteCasted
                        ? null
                        : () {
                            if (_naRadioGroupValue == -1) {
                              showAlertDialog(context, 'Unable to proceed',
                                  'Please select a party to vote.');
                            } else {
                              setState(() {
                                paVoteCasted = true;
                              });
                              controller.jumpToPage(2);
                            }
                          },
                    shape: Border.all(
                      color: paVoteCasted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).accentColor,
                    ),
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: paVoteCasted
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Theme.of(context).backgroundColor,
          ),

          //End of second page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Text(
                  'NATIONAL ASSEMBLY',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                    child: SizedBox(
                  height: 194,
                  child: pieChart,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  'PROVINCIAL ASSEMBLY',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Card(
                    child: SizedBox(
                  height: 194,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: barChart,
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatarWithShadow(),
                  ]),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.federalretirees.ca/~/media/Images/Advocacy/ElectionBallot_553558978.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.assessment,
                      color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Live Results'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                controller.jumpToPage(2);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings,
                      color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Settings'),
                  ),
                ],
              ),
              onTap: null,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.help_outline,
                      color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Help & Feedback'),
                  ),
                ],
              ),
              onTap: null,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.info, color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('About'),
                  ),
                ],
              ),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Border.all(
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, Map data, int index) {
    final record = FirebaseNaResponse.fromMap(data);

    return RadioListItem(
      flag: record.flag,
      fullName: record.fullName,
      index: index,
      initials: record.initials,
      radioValue1: _naRadioGroupValue,
      onChanged: _handleRadioValueChange1,
    );
  }
}

class Track {
  final String day;
  final int steps;

  Track(this.day, this.steps);
}

class Provincial {
  final String province;
  final int votes;
  final String party;

  Provincial(this.province, this.votes, this.party);
}

class FirebaseNaResponse {
  final String color;
  final String flag;
  final String fullName;
  final String initials;
  final int numberOfVoters;
  final DocumentReference reference;

  FirebaseNaResponse.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['color'] != null),
        assert(map['flag'] != null),
        assert(map['fullName'] != null),
        assert(map['initials'] != null),
        color = map['color'],
        flag = map['flag'],
        fullName = map['initials'],
        initials = map['initials'],
        numberOfVoters = map['numberOfVoters'];

  FirebaseNaResponse.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class Record {
  final String name;
  final int age;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['age'] != null),
        name = map['name'],
        age = map['age'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$age>";
}

class CircleAvatarWithShadow extends StatelessWidget {
  const CircleAvatarWithShadow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).accentColor,
        radius: 32.0,
        child: Container(),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
          ),
        ],
        shape: BoxShape.circle,
      ),
    );
  }
}

class RadioListItem extends StatelessWidget {
  const RadioListItem({
    Key key,
    @required int radioValue1,
    @required int index,
    @required this.onChanged,
    @required this.fullName,
    @required this.initials,
    @required this.flag,
  })  : _radioValue1 = radioValue1,
        _index = index,
        super(key: key);

  final int _radioValue1;
  final int _index;
  final String fullName;
  final String initials;
  final String flag;
  final RadioCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: _index,
            activeColor: Theme.of(context).accentColor,
            groupValue: _radioValue1,
            onChanged: onChanged,
          ),
          title: Text(
            fullName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            initials,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: CircleAvatar(
            backgroundImage: NetworkImage(flag),
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          indent: 16.0,
        ),
      ],
    );
  }
}

typedef RadioCallback = void Function(int value);
