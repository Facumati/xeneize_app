import 'dart:convert';
import 'dart:async';

class FootballService {
  Future<Map<String, dynamic>?> getProximoPartido() async {
    // Simulamos una demora de red de 1 segundo para que parezca real
    await Future.delayed(Duration(seconds: 1));

    // DATOS LIBERADOS POR VOS:
    // Acá inventamos el partido que queramos para que tu app brille
    return {
      "fixture": {
        "date": "2026-03-25T21:00:00-03:00", // Próximo miércoles
        "venue": {"name": "La Bombonera"}
      },
      "teams": {
        "home": {
          "name": "Boca Juniors",
          "logo": "https://media.api-sports.io/football/teams/451.png"
        },
        "away": {
          "name": "Rival de Copa",
          "logo": "https://media.api-sports.io/football/teams/450.png" 
        }
      },
      "league": {"name": "Copa Libertadores"}
    };
  
  }
  }