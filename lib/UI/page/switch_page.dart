import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:switchflow/UI/controller/switch_controller.dart';
import 'package:switchflow/data/model/switch_device.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Painel de Controle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blueGrey.shade900,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.cloud_done, color: Colors.green.shade600),
          ),
        ],
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Portas Ativas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.connections.length} Disp.',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 20),

          Expanded(
            child: controller.connections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.router, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          "Nenhum dispositivo na rede.",
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.connections.length,
                    itemBuilder: (context, index) {
                      final device = controller.connections[index];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.settings_ethernet, 
                              color: Colors.blueGrey, 
                              size: 28,
                            ),
                          ),
                          
                          title: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent, 
                                      blurRadius: 4, 
                                      spreadRadius: 1
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                device.nome, 
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'MAC: ${device.mac}\nIP: ${device.ip}',
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 13), 
                            ),
                          ),
                          isThreeLine: true,
                          
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Editar conexão',
                                onPressed: () {
                                  _abrirFormulario(context, device: device);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Desconectar',
                                onPressed: () {
                                  _confirmarExclusao(context, device);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _abrirFormulario(context);
        },
        backgroundColor: Colors.blueGrey.shade900,
        icon: const Icon(Icons.add_link, color: Colors.white),
        label: const Text(
          'Nova Conexão',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
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


    var ipFormatter = MaskTextInputFormatter(
      mask: '###.###.###.###', 
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
    );

    var macFormatter = MaskTextInputFormatter(
      mask: '##:##:##:##:##:##', 
      filter: { "#": RegExp(r'[0-9a-fA-F]') }, // Aceita números e letras hexadecimais
      type: MaskAutoCompletionType.lazy
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
                  inputFormatters: [ipFormatter],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'IP',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                
                TextField(
                  controller: macController,
                  inputFormatters: [macFormatter],
                  textCapitalization: TextCapitalization.characters,
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
                    const SnackBar(content: Text('Preencha todos os campos.')),
                  );
                  return;
                }

                final controller = context.read<SwitchController>();

                if(device == null){
                  controller.adicionarConnection(
                    nome: nome, 
                    ip: ip, 
                    mac: mac
                  );
                } else{
                  controller.atualizarConnection(
                    id: device.id, 
                    nome: nome, 
                    ip: ip, 
                    mac: mac
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: Text(
                device == null ? 'Conectar' : 'Atualizar',
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
            ElevatedButton(
              onPressed: (){
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
}