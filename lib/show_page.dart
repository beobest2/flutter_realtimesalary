import 'package:flutter/material.dart';
import 'liquid_progress_indicator/liquid_progress_indicator.dart';

class DisplayMoney extends StatelessWidget {
  int salary;
  int payday;

  DisplayMoney(this.salary, this.payday);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Money',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MoneyShow(salary, payday),
    );
  }
}

class MoneyShow extends StatefulWidget {
  int salary;
  int payday;

  MoneyShow(this.salary, this.payday);

  @override
  _MoneyShowState createState() => _MoneyShowState();
}

class _MoneyShowState extends State<MoneyShow> {
  bool _buttonPressed = false;
  bool _loopActive = false;

  String _current_pay = "궁금하면 오백원";
  double _current_ratio = 0.0;

  // 아래 각 단위 애니메이션 비율
  double _big_ratio = 0.0;
  double _second_ratio = 0.0;
  double _third_ratio = 0.0;
  double _fourth_ratio = 0.0;
  double _fifth_ratio = 0.0;

  List<double> _income_till_yesterday(int salary, int payday) {
    double d_salary = salary.toDouble();

    DateTime _now = DateTime.now();

    // 지난 월급날 계산
    DateTime _last_payday;
    if (_now.day > payday) {
      // 이번달 월급 날이 지난 경우 = 지난 월급날은 이번달
      _last_payday = new DateTime(_now.year, _now.month, payday);
    } else {
      // 이번달 월급날이 아직 오지 아닌 경우 = 지난 월급날은 저번달
      _last_payday = new DateTime(_now.year, _now.month - 1, payday);
    }
    // 어제까지 흐른 시간 비율 계산
    double diff_ratio =
        (_now.difference(_last_payday).inDays - 1).toDouble() / 30.0;
    // 어제까지의 월급 계산
    double salary_till_yesterday = (d_salary * 10000.0) * diff_ratio;

    return [diff_ratio, salary_till_yesterday];
  }

  List<double> _calculate_mine(
      double diff_ratio, double salary_till_yesterday, int salary, int payday) {
    double d_salary = salary.toDouble();
    DateTime _now = DateTime.now();

    // 타이머를 위해 오늘을 밀리세컨으로 환산
    int today_milisecond =
        (_now.hour * 3600 + _now.minute * 60 + _now.second) * 1000 +
            _now.millisecond;
    // 하루에 받는 돈을 계산
    double day_pay = d_salary * 10000.0 / 30.0;
    // 오늘 부터 시작해서 현재 까지 밀리세컨드로 쌓인 돈
    double today_diff_ratio = today_milisecond.toDouble() / 86400000.0;
    double now_pay = day_pay * today_diff_ratio;

    double current_money = now_pay + salary_till_yesterday;

    // 현재까지 쌓인 돈의 비율 계산 (어제까지 비율 + (오늘 비율 / 30일))
    double current_money_percentage =
        (diff_ratio + (today_diff_ratio / 30.0)) * 100.0;

    return [current_money_percentage, current_money];
  }

  @override
  Widget build(BuildContext context) {
    int salary = widget.salary;
    int payday = widget.payday;

    // 어제까지의 수익 비율과 수익을 리스트로 반환
    List<double> _yesterday_list =
        _income_till_yesterday(widget.salary, widget.payday);
    double _diff_ratio = _yesterday_list[0];
    double _income_yesterday = _yesterday_list[1];

    void changeState() async {
      if (_loopActive) return;
      _loopActive = true;
      while (_buttonPressed) {
        setState(() {
          List<double> current_result =
              _calculate_mine(_diff_ratio, _income_yesterday, salary, payday);
          double d_current_ratio = current_result[0];
          double d_current_pay = current_result[1];

          _big_ratio = (d_current_pay % 10000.0) / 10000.0;
          _second_ratio = (d_current_pay % 1000.0) / 1000.0;
          _third_ratio = (d_current_pay % 100.0) / 100.0;
          _fourth_ratio = (d_current_pay % 10.0) / 10.0;
          _fifth_ratio = (d_current_pay % 1);

          // 만원 단위 계산
          String big_num = (d_current_pay ~/ 10000.0).toString();
          // 천원 단위 계산
          String second_num = ((d_current_pay % 10000.0) ~/ 1000.0).toString();
          // 백원 단위 계산
          String third_num = ((d_current_pay % 1000.0) ~/ 100.0).toString();
          // 십원 단위 계산
          String fourth_num = ((d_current_pay % 100.0) ~/ 10.0).toString();
          // 일원 단위 계산
          String fifth_num = (d_current_pay % 10.0).toInt().toString();
          //
          String sixth_num = (d_current_pay % 1).toStringAsFixed(3);

          _current_pay =
              "$big_num만 $second_num$third_num$fourth_num$fifth_num원 $sixth_num";
          _current_ratio = d_current_ratio;
        });
        // wait a bit
        await Future.delayed(Duration(milliseconds: 100));
      }
      _loopActive = false;
    }

    String str_currentratio = _current_ratio.toStringAsFixed(5);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            '현재까지 벌고 있는 돈',
            style: TextStyle(
                fontSize: 60.0, fontFamily: "Dokdo", color: Colors.white),
          ),
          SizedBox(
            width: 150,
            height: 150,
            child: LiquidCircularProgressIndicator(
              value: _current_ratio / 100.0,
              // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
              // Defaults to the current Theme's accentColor.
              backgroundColor: Colors.white,
              // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.blueAccent,
              borderWidth: 1.0,
              direction: Axis.vertical,
              // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
              center: Text('$str_currentratio %',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Sunflower",
                      color: Colors.black54)),
            ),
          ),
          Text(
            _current_pay,
            style: TextStyle(
                fontSize: 40.0, fontFamily: "Sunflower", color: Colors.white70),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 65,
                height: 65,
                child: LiquidCircularProgressIndicator(
                  value: _big_ratio,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
                  center: Text("만 원",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Sunflower",
                          color: Colors.black)),
                ),
              ),
              SizedBox(
                width: 65,
                height: 65,
                child: LiquidCircularProgressIndicator(
                  value: _second_ratio,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
                  center: Text("천 원",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Sunflower",
                          color: Colors.black)),
                ),
              ),
              SizedBox(
                width: 65,
                height: 65,
                child: LiquidCircularProgressIndicator(
                  value: _third_ratio,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
                  center: Text("백 원",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Sunflower",
                          color: Colors.black)),
                ),
              ),
              SizedBox(
                width: 65,
                height: 65,
                child: LiquidCircularProgressIndicator(
                  value: _fourth_ratio,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.yellow),
                  center: Text("십 원",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Sunflower",
                          color: Colors.black)),
                ),
              ),
              SizedBox(
                width: 65,
                height: 65,
                child: LiquidCircularProgressIndicator(
                  value: _fifth_ratio,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                  center: Text("일 원",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Sunflower",
                          color: Colors.black)),
                ),
              ),
            ],
          ),
          Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                changeState();
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/500.jpg"),
                // backgroundColor: Colors.black,
              )),
          Listener(

          )
        ],
      )),
    );
  }
}
