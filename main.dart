import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import 'package:switchflow/UI/controller/switch_controller.dart';
import 'package:switchflow/UI/page/switch_page.dart';
import 'package:switchflow/data/repository/switch_repository.dart';
import 'package:switchflow/data/service/switch_service.dart'; 




void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){

    final switchService = SwitchService();
    final switchRepository = SwitchRepository(service: switchService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SwitchController>(
          
          create: (_) => SwitchController(
            
            repository: switchRepository,
            )..carregarConnections(),
            ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Switch Flow',

        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          
        ),

        home: const SwitchPage(),
      ),
      );
  }
}