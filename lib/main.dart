import 'package:flutter/material.dart';
import 'show_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Salary',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Realtime Salary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final salary_controller = TextEditingController();
  final payday_controller = TextEditingController();

  @override
  void dispose() {
    salary_controller.dispose();
    payday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("images/money.jpg"),
                )),
            Text(
              '얼만큼 벌고 있나 알아볼까요?',
              style: TextStyle(fontSize: 40.0, fontFamily: "Dokdo"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: salary_controller,
                decoration: InputDecoration(
                    hintText: "월급 ( 만 원 )", icon: Icon(Icons.monetization_on)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: payday_controller,
                decoration: InputDecoration(
                    hintText: "월급 날 ( 일 )", icon: Icon(Icons.today)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayMoney(
                      int.parse(salary_controller.text),
                      int.parse(payday_controller.text))));
        },
        child: Icon(Icons.find_in_page),
      ),
    );
  }
}
