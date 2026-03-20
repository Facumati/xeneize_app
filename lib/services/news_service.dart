import 'package:http/http.dart' as http;
import 'api_config.dart'; // Importamos nuestro archivo de configuración

class NewsService {
  Future<void> getNews() async {
    final response = await http.get(Uri.parse(ApiConfig.baseUrlNews));
    
    if (response.statusCode == 200) {
      print("¡Conexión exitosa! Datos recibidos: ${response.body}");
    } else {
      print("Error: ${response.statusCode}");
    }
  }
}