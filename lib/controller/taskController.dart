import 'package:get/get.dart';
import 'package:loginpage/model/Task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TaskController extends GetxController {
  RxBool loading = true.obs;
  RxList<Task> tasks = <Task>[].obs;
  RxList<Task> searchedTasks = <Task>[].obs;
  RxString searchText="".obs;

  RxBool deleting=false.obs;
  RxString deletingId="".obs;

  onInit(){
    everAll([searchText,tasks], (_){
      searchTask();
    });
  }

  setTask() async {
    var url = "https://api-nodejs-todolist.herokuapp.com/task";

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String userToken = prefs.getString("user_token");

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $userToken"
    };

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url), headers: header);
    tasks.clear();

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse['data'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
    } else {}

    loading.value = false;
  }


  addTask(String description)async{
    var url ="https://api-nodejs-todolist.herokuapp.com/task";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String userToken = prefs.getString("user_token");

    Map<String,String> header={
      "Content-Type":"application/json",
      "Authorization": "Bearer $userToken"

    };

    Map<String,String> body={
      "description": description
    };
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(Uri.parse(url),body: convert.jsonEncode(body),headers: header);
    if (response.statusCode == 201) {
      var jsonResponse =
      convert.jsonDecode(response.body) ;
      this.tasks.add(Task.fromJson(jsonResponse['data']));
     Get.back();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      Get.snackbar("خطلا", "اطلاعات رو درست وارد کنید",backgroundColor: Colors.red,);
    }
  }


  updateTask(Task task)async{

    var index=tasks.indexOf(task);
    task..completed=!task.completed;
    tasks[index]=task;
    var url ="https://api-nodejs-todolist.herokuapp.com/task/${task.sId}";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String userToken = prefs.getString("user_token");

    Map<String,String> header={
      "Content-Type":"application/json",
      "Authorization": "Bearer $userToken"

    };

    Map<String,String> body={
      "completed": "${task.completed}"
    };
    // Await the http get response, then decode the json-formatted response.
    var response = await http.put(Uri.parse(url),body: convert.jsonEncode(body),headers: header);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) ;
      print('****** ${jsonResponse}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
      task..completed=!task.completed;
      tasks[index]=task;
      Get.snackbar("خطا", "اطلاعات رو درست وارد کنید",backgroundColor: Colors.red,colorText: Colors.white);
    }
  }


  deleteTask(Task task)async{

    deleting.value=true;
    deletingId.value=task.sId;
    var index=tasks.indexOf(task);


    var url ="https://api-nodejs-todolist.herokuapp.com/task/${task.sId}";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String userToken = prefs.getString("user_token");

    Map<String,String> header={
      "Content-Type":"application/json",
      "Authorization": "Bearer $userToken"

    };


    // Await the http get response, then decode the json-formatted response.
    var response = await http.delete(Uri.parse(url),headers: header);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) ;
      print('****** ${jsonResponse}');
      tasks.removeAt(index);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      task..completed=!task.completed;
      Get.snackbar("خطا", "اطلاعات رو درست وارد کنید",backgroundColor: Colors.red,colorText: Colors.white);
    }

    deleting.value=false;
  }


  searchTask(){
    searchedTasks.clear();
    if(searchText.isEmpty){
      searchedTasks.addAll(tasks);
    }else{
      tasks.forEach((Task task) {
        if(task.description.toLowerCase().contains(searchText.toLowerCase())){
          searchedTasks.add(task);
        }
      });
    }
  }

}
