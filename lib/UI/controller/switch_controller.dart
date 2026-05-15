import 'package:flutter/material.dart';

import '../../data/model/switch.dart';
import '../../data/repository/switch_repository.dart';


class SwitchController extends ChangeNotifier{
    final SwitchRepository repository;

    SwitchController({
        required this.repository,
    });


    List<SwitchDevice> _connections = [];

    List<SwitchDevice> get connections => _connections;


    void carregarConnections(){
        _connections = repository.listar();

        notifyListeners();
    }


    void adicionarConnection({
        required String nome,
        required String ip,
        required String mac,
    }){
        final newConnection = SwitchDevice(
            id: DateTime.now().microsecondsSinceEpoch.toString(), 
            nome: nome,
            ip: ip,
            mac: mac,
            );
            repository.adicionar(newConnection);

            carregarConnections();
    }

    void atualizarSwitch({
        required String id,
        required String nome,
        required String ip,
        required String mac,
    }){
        final deviceUpdated = SwitchDevice(
        id: id, 
        nome: nome,
        ip: ip,
        mac: mac,
        );

        repository.atualizar(deviceUpdated);
        carregarConnections();
    }


    void removerSwitch(String id){
        repository.remover(id);
        carregarConnections();
    }

    SwitchDevice? buscarPorId(String id){
        return repository.buscarPorId(id);
    }

    SwitchDevice? buscarPorIp(String ip){
        return repository.buscarPorIp(ip);
    }

}