
import '../model/switch.dart';
import '../service/switch_service.dart';


class SwitchRepository {
  final SwitchService service;

  SwitchRepository({
    required this.service,
  });



  List<SwitchDevice> listar(){
    return service.getAll();
  }

  
  void adicionar(SwitchDevice device){
    service.insert(device);
  }

  void atualizar(SwitchDevice device){
    service.update(device);
  }

  void remover(String id){
    service.delete(id);
  }


  SwitchDevice? buscarPorId(String id){
    return service.findById(id);
  }

  SwitchDevice? buscarPorIp(String ip){
    return service.findByIp(ip);
  }
}


