import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';

class UpdateTask extends StatefulWidget {
  final t_id, t_tl_id, t_createdate, t_detail;
  UpdateTask(this.t_id, this.t_tl_id, this.t_createdate, this.t_detail);
  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  TextEditingController detail = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController u_fullname = TextEditingController();

  List tasklistData = [];
  var _t_id;
  var _t_tl_id;
  var _t_createdate;
  var _t_detail;

  var dropdownValue;
  @override
  void initState() {
    super.initState();
    u_fullname.text = "ขจรศักดิ์ ผักใบเขียว";
    _t_id = widget.t_id;
    dropdownValue = widget.t_tl_id;
    _t_createdate = widget.t_createdate.toString();
    dateinput.text = _t_createdate.substring(0, 10);
    timeinput.text = _t_createdate.substring(11);
    // _t_detail = widget.t_detail;
    detail.text = widget.t_detail.toString();
    getTasklist();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Text('แก้ไขกิจกรรม',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ]),
            ),
            preferredSize: Size(40, 40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Text("รายการกิจกรรมของโครงการ"),
              SizedBox(
                width: 15,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      print(dropdownValue);
                    });
                  },
                  items: tasklistData.map((item) {
                    return DropdownMenuItem(
                      value: item['tl_id'].toString(),
                      child: Text(item['tl_name'].toString()),
                    );
                  }).toList(),
                  value: dropdownValue,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Expanded(child: Text("วันที่ดำเนินการ")),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: Text("เวลาที่ดำเนินการ"))
              ]),
              Row(children: [
                Expanded(
                  child: TextField(
                      controller: dateinput,
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                      controller: timeinput,
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            timeinput.text =
                                formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Text("ผู้เพิ่มกิจกรรม"),
              TextField(
                  style: TextStyle(color: Colors.grey),
                  controller: u_fullname,
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                  )),
              SizedBox(
                height: 15,
              ),
              Text("รายละเอียดกิจกรรม"),
              TextField(
                  minLines: 4,
                  maxLines: 8,
                  controller: detail,
                  decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  print('--------Update Success-----------');
                  updateTask().then((value) {
                    Navigator.pop(context);
                  });
                  final snackBar = SnackBar(
                    content: const Text('แก้ไขกิจกรรมสำเร็จ'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("แก้ไขกิจกรรม"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 20))),
              ),
            ],
          ),
        ));
  }

  Future getTasklist() async {
    var url = Uri.http(
        'dekdee2.informatics.buu.ac.th:9080', '/team0/api/getTasklist');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    var data = jsonDecode(result);

    setState(() {
      tasklistData = jsonDecode(result);
    });
  }

  Future updateTask() async {
    var url = Uri.http(
        'dekdee2.informatics.buu.ac.th:9080', '/team0/api/updateTask/${_t_id}');
    Map<String, String> header = {"Content-type": "application/json"};
    if (dropdownValue == "" ||
        detail.text == "" ||
        dateinput.text == "" ||
        timeinput.text == "") {
      final snackBar = SnackBar(
        content: const Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String datetime = dateinput.text + " " + timeinput.text;
    String jsondata =
        '{"t_detail":"${detail.text}", "t_createdate":"${datetime}", "t_tl_id":"${dropdownValue}"}';
    var response = await http.put(url, headers: header, body: jsondata);
    print(response.body);
  }
}
