import 'package:flutter/material.dart';

class todocard extends StatefulWidget {
  const todocard({super.key, required this.title, required this.icon, required this.time, required bool check});
  final String title;
   final IconData icon;
   final String time;
  final bool check=false;



  @override
  State<todocard> createState() => _todocardState();
}

class _todocardState extends State<todocard> {
  bool bool2=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Colors.deepPurple,
            ),
          child:Transform.scale(
            scale: 1.5,
            child: Checkbox(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              activeColor: Colors.pinkAccent,
              checkColor: Colors.orange,
              value: bool2, onChanged:(bool? value){
              setState(() {
              bool2=value!;
              });
            },
            ),
          ),
          ),
          Container(
            height: 75,
           // color: Colors.grey,
             width: 300,
            child: Card(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular((12))),
              color: Colors.grey[600], child: Row(
                children: [
                  //SizedBox(width: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.icon),
                    ),
                  ),
                  SizedBox(width: 20,),

                  Expanded( child:Text(widget.title,style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),),),
                  Text(widget.time,style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  SizedBox(width: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
