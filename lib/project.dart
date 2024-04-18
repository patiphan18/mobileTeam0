import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'task/list.dart';

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  List projectData = [];
  String stauts = "";
  @override
  void initState() {
    super.initState();
    getProjects();
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
                      child: Text('รายชื่อโครงการ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ]),
            ),
            preferredSize: Size(40, 40),
          ),
        ),
        body: projectList());
  }

  Widget projectList() {
    return projectData.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
                itemCount: projectData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListTask(
                                        projectData[index]['p_id'],
                                        projectData[index]['p_name'],
                                        projectData[index]['p_status'],
                                        projectData[index]['p_createdate'],
                                        projectData[index]['p_enddate'])))
                            .then((value) => setState(() {
                                  getProjects();
                                }));
                      },
                      child: ListTile(
                        leading: showIcon(projectData[index]['p_status']),
                        title: Text(
                          '${projectData[index]['p_name']}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: showStatus(projectData[index]['p_status']),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListTask(
                                            projectData[index]['p_id'],
                                            projectData[index]['p_name'],
                                            projectData[index]['p_status'],
                                            projectData[index]['p_createdate'],
                                            projectData[index]['p_enddate'])))
                                .then((value) => setState(() {
                                      getProjects();
                                    }));
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.transparent;
                              },
                            ),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 25.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            onRefresh: getProjects,
          )
        : Center(child: CircularProgressIndicator());
  }

  Future getProjects() async {
    var url = Uri.http(
        'dekdee2.informatics.buu.ac.th:9080', '/team0/api/getAllProjects');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    setState(() {
      projectData = jsonDecode(result);
    });
  }

  showStatus(p_status) {
    if (p_status == "1") {
      return Text('รอดำเนินการ');
    } else if (p_status == "2") {
      return Text('กำลังดำเนินการ');
    } else if (p_status == "3") {
      return Text('สิ้นสุด');
    } else if (p_status == "4") {
      return Text('ถูกยุติ');
    } else {
      return Text('ถูกลบ');
    }
  }

  showIcon(p_status) {
    if (p_status == "1") {
      return Container(
        height: 50,
        width: 50,
        child: Icon(
          Icons.insert_drive_file,
          size: 30,
          color: Color.fromARGB(255, 254, 193, 7),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 255, 239, 189),
        ),
      );
    } else if (p_status == "2") {
      return Container(
        height: 50,
        width: 50,
        child: Icon(
          Icons.insert_drive_file,
          size: 30,
          color: Colors.blue,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 187, 240, 251),
        ),
      );
    } else if (p_status == "3") {
      return Container(
        height: 50,
        width: 50,
        child: Icon(
          Icons.insert_drive_file,
          size: 30,
          color: Colors.green,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[50],
        ),
      );
    } else if (p_status == "4") {
      return Container(
        height: 50,
        width: 50,
        child: Icon(
          Icons.insert_drive_file,
          size: 30,
          color: Colors.red,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red[50],
        ),
      );
    } else {
      return Container(
        height: 50,
        width: 50,
        child: Icon(
          Icons.insert_drive_file,
          size: 30,
          color: Colors.black,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      );
    }
  }
}
