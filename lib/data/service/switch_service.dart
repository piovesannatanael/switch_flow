import '../model/switch_device.dart';

class SwitchService {
  final List<SwitchDevice> _connections = [];


List<SwitchDevice> getAll(){
  return List<SwitchDevice>.from(_connections);
}

/// CRUD

void insert(SwitchDevice device) {
  _connections.add(device);
}



void update(SwitchDevice deviceUpdated){
  final index = _connections.indexWhere((dispositivo) => dispositivo.id == deviceUpdated.id);

  if (index != -1){
    _connections[index] = deviceUpdated;
  }
}


void delete(String id){
  _connections.removeWhere((dispositivo) => dispositivo.id == id);
}


/// Buscas

  SwitchDevice? findById(String id){
    try{
      return _connections.firstWhere((dispositivo) => dispositivo.id == id);
    } catch (_){
      return null;
    }
  }

 SwitchDevice? findByIp(String ip){
    try{
      return _connections.firstWhere((dispositivo) => dispositivo.ip == ip);
    } catch (_){
      return null;
    }
  }

}
