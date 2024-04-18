import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'add.dart';
import 'update.dart';

class ListTask extends StatefulWidget {
  // const ListTask({super.key});
  final p_id, p_name, p_status, p_createdate, p_enddate;
  ListTask(
      this.p_id, this.p_name, this.p_status, this.p_createdate, this.p_enddate);
  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  List taskData = [];
  var _p_id, _p_name, _p_status, _p_createdate, _p_enddate;
  var res = -1;
  @override
  void initState() {
    super.initState();
    _p_id = widget.p_id;
    _p_name = widget.p_name;
    _p_status = widget.p_status;
    _p_createdate = widget.p_createdate;
    _p_enddate = widget.p_enddate;
    getTasks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTask(_p_id)))
              .then((value) => setState(() {
                    getTasks();
                  }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 169, 243),
        titleSpacing: 0,
        title: Container(
          height: 56,
          color: Color.fromARGB(255, 3, 160, 231),
          padding: const EdgeInsets.only(right: 15, left: 10),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.fitWidth,
                ),
                new TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(30, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ]),
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.white,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('กิจกรรมของโครงการ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]),
          ),
          preferredSize: Size(40, 40),
        ),
      ),
      body: projectList(),
    );
  }

  Widget projectList() {
    return res == 1
        ? taskData.length != 0
            ? RefreshIndicator(
                child: ListView.builder(
                    itemCount: taskData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          showProjectDetail(index),
                          showHeader(index),
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: const ColoredBox(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              deleteTask(taskData[index]['t_id'])
                                  .then((value) => setState(() {
                                        getTasks();
                                      }));
                              final snackBar = SnackBar(
                                content: const Text('ลบกิจกรรมสำเร็จ'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: Card(
                              child: InkWell(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text('${taskData[index]['tl_name']}', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue)),
                                      new Text("${taskData[index]['t_createdate'].toString().substring(10,16)} น.",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  subtitle: 
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text('วันที่ดำเนินการ : ${taskData[index]['t_createdate'].toString().substring(0,10)}'), 
                                      new Text("ผู้ดำเนินการ : ขจรศักดิ์ ผักใบเขียว")
                                    ],
                                  ),
                                  
                                  ),
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateTask(
                                              taskData[index]['t_id'],
                                              taskData[index]['t_tl_id'],
                                              taskData[index]['t_createdate'],
                                              taskData[index]
                                                  ['t_detail']))).then(
                                      (value) => setState(() {
                                            getTasks();
                                          })),
                                },
                              ),
                            ),
                          ),
                          showFooter(index),
                        ],
                      );
                    }),
                onRefresh: getTasks,
              )
            : Center(child: CircularProgressIndicator())
        : Center(
            child: isEmpty(res),
          );
  }

  Future getTasks() async {
    var url = Uri.http('dekdee2.informatics.buu.ac.th:9080',
        '/team0/api/getProjectTasks/${_p_id}');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    var data = jsonDecode(result);
    if (data[0] == null) {
      setState(() {
        res = 0;
      });
    } else {
      setState(() {
        taskData = jsonDecode(result);
        res = 1;
      });
    }
  }

  isEmpty(res) {
    if (res == -1) {
      return CircularProgressIndicator();
    } else {
      return Text('ไม่มีกิจกรรม');
    }
  }

  showProjectDetail(i) {
    if (i == 0) {
      return Card(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        child: InkWell(
          child: ListTile(
            title: Text('${_p_name}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            subtitle: 
            Padding(padding: EdgeInsets.only(top: 10),child: Table(
              children: [
                TableRow(children: [
                  Text(
                    "ผู้รับผิดชอบหลัก : ขจรศักดิ์ ผักใบเขียว",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "สถานะ : ${showStatus(_p_status)}",
                    style: TextStyle(fontSize: 13),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "วันที่เริ่มโครงการ : ${_p_createdate}",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "วันที่สิ้นสุดโครงการ : -",
                    style: TextStyle(fontSize: 13),
                  ),
                ]),
              ],
            ),)
            
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  showHeader(i) {
    if (i == 0) {
      return Card(
        child: InkWell(
          child: ListTile(
            title: Text('กิจกรรมของโครงการ'),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  showFooter(i) {
    if (i == taskData.length - 1) {
      return SizedBox(
        height: 60,
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  showStatus(p_status) {
    if (p_status == "1") {
      return 'รอดำเนินการ';
    } else if (p_status == "2") {
      return 'กำลังดำเนินการ';
    } else if (p_status == "3") {
      return 'สิ้นสุด';
    } else if (p_status == "4") {
      return 'ถูกยุติ';
    } else {
      return 'ถูกลบ';
    }
  }
}

Future deleteTask(t_id) async {
  var url = Uri.http(
      'dekdee2.informatics.buu.ac.th:9080', '/team0/api/deleteTask/${t_id}');
  Map<String, String> header = {"Content-type": "application/json"};
  var response = await http.delete(url, headers: header);
  print('------result-------');
  print(response.body);
}
