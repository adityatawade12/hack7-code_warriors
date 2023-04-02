import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/color_extensions.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ), body: BarChartSample4(),
    );
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class BarChartSample4 extends StatefulWidget {
  BarChartSample4({super.key});

  final Color dark = AppColors.contentColorCyan.darken(60);
  final Color normal = AppColors.contentColorCyan.darken(30);
  final Color light = AppColors.contentColorCyan;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  // var data_set = {};
  // Future<Map<String, dynamic>> getDataJson() async {
  //   final jsonString = await rootBundle.loadString('assets/dataset2.json');
  //   return json.decode(jsonString);
  // }
 
  Widget bottomTitles(double value, TitleMeta meta) {
    
    // print(data);
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'March';
        break;
      case 3:
        text = 'April';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'June';
        break;
      case 6:
        text = 'July';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sept';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 4.0 * constraints.maxWidth / 400;
            final barsWidth = 8.0 * constraints.maxWidth / 400;
            return FutureBuilder(
              future: getData(barsWidth, barsSpace),
              builder: (context, snapshot){
            
                if(snapshot.data == null) return const SizedBox();
                return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: snapshot.data
              ),
            );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<BarChartGroupData>> getData(double barsWidth, double barsSpace) async{
    var data_set = {};
    Future<Map<String, dynamic>> getDataJson() async {
      final jsonString = await rootBundle.loadString('assets/dataset2.json');
      return json.decode(jsonString);
    }
    await getDataJson().then((data) {
      data_set = data;
    // print(data);
  
    }).catchError((error) {
    print('Error reading JSON file: $error');
    });
    var expenditures=[];
    var incomes = [];
    var groceries = [];
    var entertainment = [];
    var travel = [];
    // print(data_set['month'][0]['expenditure']);
    for (var i = 0; i < 12; i++){
      expenditures.add(double.parse(data_set['month'][i]['expenditure']));
      incomes.add(double.parse(data_set['month'][i]['income'])) ;
      groceries.add(double.parse(data_set['month'][i]['categories'][0]['amount'])) ;
      entertainment.add(double.parse(data_set['month'][i]['categories'][1]['amount'])) ;
      travel.add(double.parse(data_set['month'][i]['categories'][2]['amount'])) ;
      }
    // print(expenditures[0]);
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            //expenditure
            toY: expenditures[0],
            // toY: 13777777777,
            rodStackItems: [
              BarChartRodStackItem(0, groceries[0], widget.dark),//groceries
              BarChartRodStackItem(groceries[0], groceries[0] + entertainment[0], widget.normal),//entertainment
              BarChartRodStackItem(groceries[0] + entertainment[0],groceries[0] + entertainment[0]+travel[0] , widget.light),//travel
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            //income
            toY: incomes[0],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[0], widget.dark),
              // BarChartRodStackItem(13000000000, 14000000000, widget.normal),
              // BarChartRodStackItem(14000000000, 24000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[1],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[1], widget.dark),
              BarChartRodStackItem(groceries[1], groceries[1]+entertainment[1], widget.normal),
              BarChartRodStackItem(groceries[1]+entertainment[1], groceries[1]+entertainment[1]+travel[1], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[1],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[1], widget.dark),
              // BarChartRodStackItem(0, 0, widget.normal),
              // BarChartRodStackItem(0, 0, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[2],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[2], widget.dark),
              BarChartRodStackItem(groceries[2], groceries[2]+entertainment[2], widget.normal),
              BarChartRodStackItem(groceries[2]+entertainment[2], groceries[2]+entertainment[2]+travel[2], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[2],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[2], widget.dark),
              // BarChartRodStackItem(7000000000, 24000000000, widget.normal),
              // BarChartRodStackItem(24000000000, 32000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[3],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[3], widget.dark),
              BarChartRodStackItem(groceries[3], groceries[3]+entertainment[3], widget.normal),
              BarChartRodStackItem(groceries[3]+entertainment[3], groceries[3]+entertainment[3]+travel[3], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[3],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[3], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[4],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[4], widget.dark),
              BarChartRodStackItem(groceries[4], groceries[4]+entertainment[4], widget.normal),
              BarChartRodStackItem(groceries[4]+entertainment[4], groceries[4]+entertainment[4]+travel[4], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[4],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[4], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[5],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[5], widget.dark),
              BarChartRodStackItem(groceries[5], groceries[5]+entertainment[5], widget.normal),
              BarChartRodStackItem(groceries[5]+entertainment[5], groceries[5]+entertainment[5]+travel[5], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[5],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[5], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[6],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[6], widget.dark),
              BarChartRodStackItem(groceries[6], groceries[6]+entertainment[6], widget.normal),
              BarChartRodStackItem(groceries[6]+entertainment[6], groceries[6]+entertainment[6]+travel[6], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[6],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[6], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 7,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[7],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[7], widget.dark),
              BarChartRodStackItem(groceries[7], groceries[7]+entertainment[7], widget.normal),
              BarChartRodStackItem(groceries[7]+entertainment[7], groceries[7]+entertainment[7]+travel[7], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[7],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[7], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 8,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[8],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[8], widget.dark),
              BarChartRodStackItem(groceries[8], groceries[8]+entertainment[8], widget.normal),
              BarChartRodStackItem(groceries[8]+entertainment[8], groceries[8]+entertainment[8]+travel[8], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[8],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[8], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 9,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[9],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[9], widget.dark),
              BarChartRodStackItem(groceries[9], groceries[9]+entertainment[9], widget.normal),
              BarChartRodStackItem(groceries[9]+entertainment[9], groceries[9]+entertainment[9]+travel[9], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[9],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[9], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 10,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[10],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[10], widget.dark),
              BarChartRodStackItem(groceries[10], groceries[10]+entertainment[10], widget.normal),
              BarChartRodStackItem(groceries[10]+entertainment[10], groceries[10]+entertainment[10]+travel[10], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[10],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[10], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 11,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: expenditures[11],
            rodStackItems: [
              BarChartRodStackItem(0, groceries[11], widget.dark),
              BarChartRodStackItem(groceries[11], groceries[11]+entertainment[11], widget.normal),
              BarChartRodStackItem(groceries[11]+entertainment[11], groceries[11]+entertainment[11]+travel[11], widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: incomes[11],
            rodStackItems: [
              BarChartRodStackItem(0, incomes[11], widget.dark),
              // BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              // BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
