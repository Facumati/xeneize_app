import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class NewsService {
  Future<List<Map<String, String>>> fetchBocaNews() async {
    List<Map<String, String>> noticias = [];

    try {
      print("🤖 Robot: Entrando a Planeta Boca...");
      final response = await http.get(Uri.parse('https://www.planetaboca.com.ar/'));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        var elementos = document.querySelectorAll('h2, h3');

        for (var e in elementos) {
          String texto = e.text.trim();
          if (texto.length > 25) {
            noticias.add({
              'titulo': texto,
              'subtitulo': 'Novedades del Único Grande 💙💛',
            });
          }
        }
        print("🤖 Robot: ¡Encontré ${noticias.length} noticias!");
      }
    } catch (e) {
      print("🤖 Robot: Error en el área: $e");
    }

    if (noticias.isEmpty) {
      noticias.add({
        'titulo': 'Boca Juniors: El sentimiento no muere',
        'subtitulo': 'Cargando las últimas novedades...',
      });
    }

    return noticias;
  }
}

