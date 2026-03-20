import 'package:flutter/material.dart';
import 'services/football_service.dart';
import 'dart:async'; // <--- IMPORTANTE: Esto permite usar el Timer

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: XeneizeHome(),
  ));
}

class XeneizeHome extends StatefulWidget {
  const XeneizeHome({super.key});

  @override
  State<XeneizeHome> createState() => _XeneizeHomeState();
}

class _XeneizeHomeState extends State<XeneizeHome> {
  String _resultado = "Consultando datos...";
  String _tiempoRestante = "Calculando..."; // <--- Nueva variable para el reloj
  bool _cargando = true;
  Timer? _timer; // <--- El motor del cronómetro

  @override
  void initState() {
    super.initState();
    _actualizarPartido();
  }

  // Limpiamos el timer cuando cerramos la app para que no gaste batería
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarCronometro(String fechaIso) {
    _timer?.cancel();
    DateTime fechaPartido = DateTime.parse(fechaIso);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final ahora = DateTime.now();
      final diferencia = fechaPartido.difference(ahora);

      if (mounted) {
        setState(() {
          if (diferencia.isNegative) {
            _tiempoRestante = "¡JUEGA EL ÚNICO GRANDE!";
            _timer?.cancel();
          } else {
            // Formato: Días, Horas, Minutos, Segundos
            _tiempoRestante = 
              "${diferencia.inDays}d ${diferencia.inHours % 24}h ${diferencia.inMinutes % 60}m ${diferencia.inSeconds % 60}s";
          }
        });
      }
    });
  }

  void _actualizarPartido() {
    setState(() => _cargando = true);
    
    FootballService().getProximoPartido().then((partido) {
      if (mounted) {
        setState(() {
          if (partido != null) {
            final local = partido['teams']['home']['name'];
            final visitante = partido['teams']['away']['name'];
            final fechaIso = partido['fixture']['date']; // Traemos la fecha de la API
            
            _resultado = "PRÓXIMO PARTIDO:\n$local vs $visitante";
            _iniciarCronometro(fechaIso); // <--- ACTIVAMOS EL RELOJ
          } else {
            _resultado = "No hay partidos próximos.\n¡A esperar el sorteo!";
            _tiempoRestante = "--:--:--";
          }
          _cargando = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _resultado = "Error de conexión.\nVerificá tu API Key.";
          _cargando = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003057),
      appBar: AppBar(
        title: const Text("XENEIZE APP", 
          style: TextStyle(color: Color(0xFFFCB131), fontWeight: FontWeight.bold, letterSpacing: 3)),
        backgroundColor: const Color(0xFF003057),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // EL ESCUDO QUE YA CARGAMOS
            Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              padding: const EdgeInsets.all(20),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/escudo_boca.png',
                  height: 120, width: 120, fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.shield, size: 100, color: Color(0xFF003057)),
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            // TARJETA DEL PARTIDO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFFCB131),
                borderRadius: BorderRadius.circular(25),
              ),
              child: _cargando
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF003057)))
                  : Column(
                      children: [
                        Text(_resultado, textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF003057), fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(color: Color(0xFF003057), height: 30),
                        const Text("TIEMPO RESTANTE:", style: TextStyle(fontSize: 14, color: Color(0xFF003057))),
                        Text(_tiempoRestante, // <--- ACÁ SE VE EL RELOJ CORRIENDO
                          style: const TextStyle(color: Color(0xFF003057), fontSize: 28, fontWeight:  FontWeight.w900)),
                      ],
                    ),
            ),
            
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _actualizarPartido,
              icon: const Icon(Icons.refresh, color: Color(0xFF003057)),
              label: const Text("ACTUALIZAR INFO", style: TextStyle(color: Color(0xFF003057), fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCB131), shape: StadiumBorder()),
            ),
          ],
        ),
      ),
    );
  }
}