import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:switchflow/UI/controller/switch_controller.dart';
import 'package:switchflow/data/model/switch_device.dart';


class SwitchPage extends StatefulWidget{
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
} 

class _SwitchPageState extends State<SwitchPage>{

  @override 
  Widget build(BuildContext context){

    final controller = context.watch<SwitchController>();

  return Scaffold(

    appBar: AppBar(
      title: const Text('Switch Flow'),
      centerTitle: true,
    ),
    
    body: controller.connections.isEmpty ? const Center(
      child: Text("Nenhum dispositivo conectado!",
      style: TextStyle(fontSize: 18),
      ),
    )

    :ListView.builder(itemCount: controller.connections.length,
    itemBuilder: (context, index){
      final device = controller.connections[index];

      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),

        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(device.nome),
          subtitle: Text(
            'MAC: ${device.mac}\n'
            'IP: ${device.ip}',
          ),

          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              IconButton(
                
                icon: const Icon(Icons.edit),
                tooltip: 'Editar conexão',
                  
                onPressed: (){
                  _abrirFormulario(
                    context,
                    device: device,
                    );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Excluir conexão',

                onPressed: (){
                  _confirmarExclusao(context, device);
                },
              ),
            ],

          ),
        ),
      );     
    },
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: (){
        _abrirFormulario(context);
      },
      child: const Icon(Icons.add),
      ),
  );
  }
}






  void _abrirFormulario(BuildContext context, {SwitchDevice? device}){

    final nomeController = TextEditingController(
      text: device?.nome ?? '',
    );

    final ipController = TextEditingController(
      text: device?.ip ?? '',
    );

    final macController = TextEditingController(
      text: device?.mac ?? '',
    );

    showDialog(
      context: context,
       builder: (dialogContext){
          return AlertDialog(
            title: Text(
              device == null ? 'Nova conexão' : 'Editar conexão',
            ),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [


                  TextField(

                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(

                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: 'IP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),


                  TextField(

                    controller: macController,
                    decoration: const InputDecoration(
                      labelText: 'MAC',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(dialogContext);
                },
                 child: const Text('Cancelar'),
                 ),
                 
                 
                 ElevatedButton(
                  onPressed: (){
                    final nome = nomeController.text.trim();
                    final ip = ipController.text.trim();
                    final mac = macController.text.trim();

                    if(nome.isEmpty || ip.isEmpty || mac.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preencha todos os campos.'),
                        ),
                      );
                      return;
                    }

                    final controller = context.read<SwitchController>();

                    if(device == null){
                      controller.adicionarConnection(
                        nome: nome, 
                        ip: ip, 
                        mac: mac);
                    } else{
                      controller.atualizarConnection(
                        id: device.id, 
                        nome: nome, 
                        ip: ip, 
                        mac: mac);
                    }

                    Navigator.pop(dialogContext);
                  },
                   child: Text(
                    device == null ? 'Conectar' : 'Cancelar',
                   ),
                   ),
            ],
          );
       } 
       );
  }

  void _confirmarExclusao(BuildContext context, SwitchDevice device){
    showDialog(
      context: context,
       builder: (dialogContext){
          return AlertDialog(
            title: const Text('Desconectar'),
            content: Text(
              'Realmente desconectar este dispositivo?\n'
              "${device.nome}\n"
              "${device.ip}",
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(dialogContext);
                }, 
                child: const Text('Cancelar'),
                ),
                ElevatedButton(onPressed: (){
                  context.read<SwitchController>().removerSwitch(device.id);

                  Navigator.pop(dialogContext);

                },
                 child: const Text('Excluir'),
                 ),
            ],
          );
       }
       );
  }

