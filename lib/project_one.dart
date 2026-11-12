import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,//عشان نخفي علامة ال debug
          locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'),
        Locale('en'),], //عشان نخلي الابلكيشن انجلش وعربي
        localizationsDelegates: const[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],// عشان يظبط الاتجاهات والترجمة

        builder: (context,child){
        return  Directionality(textDirection: TextDirection.ltr, child: child!,
        );
        },//عشان نخلي الابلكيشن انجلش
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
             backgroundColor: Colors.white,
            // centerTitle: true,
            title:SizedBox(
             height:38 ,
           width:250 ,
           child:  TextField( decoration:InputDecoration(
                hintText: 'ابحث عن دكتور قريب منك...',
              hintStyle: TextStyle(color: Color(0x803F51B5)),
              prefixIcon:const Icon (Icons.search,color: Colors.indigo,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
                filled: true,
              fillColor: const Color(0x263A7BD5),
             contentPadding:
               EdgeInsets.symmetric(vertical: 8),
            ),),),//عشان نظهر خانة البحث
            // leading:IconButton( icon: const Icon(Icons.search_rounded,color: Colors.indigo),
            // onPressed: (){},

            actions: [ const Icon(Icons.favorite,color: Colors.pinkAccent,size: 40,),]
          ),
          backgroundColor: Colors.white,
        ),
      ),

      );

  }
//import 'package:flutter/material.dart';
//
// void main() {
//   runApp(
//     MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF42F7C0)),
//       ),
//       //routes:,
//       themeMode: ThemeMode.system,
//       //darkTheme: ,
//
//       home: Scaffold(
//         appBar: AppBar(
//           // backgroundColor: Colors.blueAccent,
//           centerTitle: true,
//           title: Text('salma'),
//           leading: Icon(Icons.message_outlined, color: Colors.purple),
//           actions: [Icon(Icons.settings), Icon(Icons.search)],
//         ),
//         backgroundColor: Color(0x121A1BFF),
//         //alignment.center
//         body: Column(
//           children: [
//             OutlinedButton(onPressed: () {}, child: Text("data0")),
//             FilledButton(
//               onPressed: () {},
//               style: FilledButton.styleFrom(
//                 backgroundColor: Colors.pink,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
//                 ),
//               ),
//               child: Text("data1"),
//             ),
//           ],
//           // mainAxisAlignment: MainAxisAlignment.start,
//           // alignment: Alignment.topCenter,
//           // children: [
//           //   Container(
//           //     color: Colors.white,
//           //     height: 100,
//           //     width: 300,
//           //     alignment: Alignment.centerLeft,
//           //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           // child: Text("data"),
//           //  padding: EdgeInsets.only(
//           //   left: 20,
//           //   right: 20,
//           //   top: 20,
//           //   bottom: 20,
//         ),
//         // Container(color: Colors.deepPurple, height: 100, width: 200),
//         // Positioned(
//         //   bottom: 10,
//         //   left: 20,
//         //   child: Container(color: Colors.orange, height: 20),
//         // ),
//         // ],
//
//         // child: Text("data"),
//         // margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
//
//         //     Text("datah", style: TextStyle(fontSize: 40, color: Colors.blue)),
//         // Text("GKLHGJKHKGUCVGHKJJVUGVKJHNHCGYG"),
//         // Text("GKLHGJKHKGUCVGHKJJVUGVKJHNHCHFHFHFGHFFGFHFGYG"),
//         // ],
//         //   // Column(
//         //   mainAxisAlignment:MainAxisAlignment.center, //column
//         //    crossAxisAlignment:CrossAxisAlignment.end , //raw
//         //   // mainAxisSize:,
//         //   // spacing: ,
//
//         // drawer: ,
//         // bottomNavigationBar: ,
//         // floatingActionButton: ,
//       ),
//     ),
//     // ),
//   );
// }