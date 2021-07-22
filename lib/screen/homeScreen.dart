import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginpage/constants.dart';
import 'package:loginpage/controller/taskController.dart';
import 'package:loginpage/model/Task.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_indicator_button/progress_button.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  TaskController taskController =Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    taskController.setTask();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
      ),
      body: _buildBody(),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         Get.bottomSheet(AddTask(),backgroundColor: Colors.white,shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
         ));
       },
       child: Icon(Icons.add),
     ),
    );
  }

 Widget _buildBody() {
    return Obx((){
      if(taskController.loading.value){
        return Center(child: SpinKitThreeBounce(
          color: mediumBlue,
          size: 50.0,
        ),);
      }else{
        return Container(
          child: Container(
            child: Column(
              children: [
                new Container(
                  padding: EdgeInsets.only(top: 15,bottom: 20,left: 8,right: 8),
                  child: TextField(
                    onChanged: (String value){
                      taskController.searchText.value=value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      labelText: "search",
                      hintText: "Search..."
                    ),
                  ),
                ),
                Expanded(child:
                taskController.searchedTasks.length==0?
                    new Center(
                      child: Text("there is no item"),
                    )
                    :
                
                ListView.builder(
                    itemCount: taskController.searchedTasks.length,
                    itemBuilder: (context,index){
                      Task task=taskController.searchedTasks[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
//                color: Colors.amber,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)
                              )
                          ),
                          child: Container(
                            child: ListTile(
                              title: Text(task.description),
                              subtitle: Text(task.createdAt.split("T").first),
                              trailing: Container(
                                width: 100,
                                height: 50,
                                child: Obx((){
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      taskController.deleting.value && taskController.deletingId.value==task.sId?
                                      Container(
                                        margin: EdgeInsets.only(right: 12),
                                        child: CupertinoActivityIndicator(),
                                      )
                                          :
                                      IconButton(icon: Icon(Icons.delete), onPressed: (){
                                        taskController.deleteTask(task);
                                      },color: Colors.red,),
                                      Checkbox(value: task.completed, activeColor: Colors.green,onChanged: (value){
                                        taskController.updateTask(task);
                                      })
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),)
              ],
            ),
          ),
        );
      }
    });
 }
}

// ignore: must_be_immutable
class AddTask extends StatelessWidget{
  String description;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Column(
        children: [
          TextField(
          onChanged: (String value){
            description=value;
          },
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(color: mediumBlue),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: mediumBlue
                  )
              ),
            ),
            maxLines: 3,
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 55,
            child: ProgressButton(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              strokeWidth: 2,
              color: mediumBlue,
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              onPressed: (AnimationController controller) async{
                  controller.forward();
                await  Get.find<TaskController>().addTask(description);
                  controller.reverse();

              },
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}



