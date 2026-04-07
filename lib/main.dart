import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/news_service.dart';
import 'services/football_service.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xeneize App',
      theme: ThemeData(primaryColor: const Color(0xFF003057)),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _indiceActual = 0;
  final List<Widget> _pantallas = [
    const XeneizeHome(),
    const NoticiasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        backgroundColor: const Color(0xFF003057),
        selectedItemColor: const Color(0xFFFCB131),
        unselectedItemColor: Colors.white60,
        onTap: (index) => setState(() => _indiceActual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Próxima Fecha"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Noticias"),
        ],
      ),
    );
  }
}

class XeneizeHome extends StatefulWidget {
  const XeneizeHome({super.key});
  @override
  State<XeneizeHome> createState() => _XeneizeHomeState();
}

class _XeneizeHomeState extends State<XeneizeHome> {
  String _resultado = "Consultando datos...";
  String _tiempoRestante = "Calculando..."; 
  bool _cargando = true;
  Timer? _timer; 

  @override
  void initState() { 
    super.initState(); 
    _actualizarPartido(); 
  }

  void _iniciarCronometro(String fechaIso) {
    _timer?.cancel();
    DateTime fechaPartido = DateTime.parse(fechaIso);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final diferencia = fechaPartido.difference(DateTime.now());
      if (mounted) {
        setState(() {
          _tiempoRestante = diferencia.isNegative ? "¡HOY JUEGA BOCA!" : 
            "${diferencia.inDays}d ${diferencia.inHours % 24}h ${diferencia.inMinutes % 60}m ${diferencia.inSeconds % 60}s";
        });
      }
    });
  }

  void _actualizarPartido() {
    setState(() => _cargando = true);
    FootballService().getProximoPartido().then((partido) {
      if (mounted && partido != null) {
        setState(() {
          _resultado = "PRÓXIMO PARTIDO:\n${partido['teams']['home']['name']} vs ${partido['teams']['away']['name']}";
          _iniciarCronometro(partido['fixture']['date']);
          _cargando = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003057),
      appBar: AppBar(
        title: const Text("XENEIZE APP", style: TextStyle(color: Color(0xFFFCB131), fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: true
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/escudo_boca.png', height: 150, errorBuilder: (c, e, s) => const Icon(Icons.shield, size: 100, color: Colors.amber)),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: const Color(0xFFFCB131), borderRadius: BorderRadius.circular(25)),
              child: _cargando ? const CircularProgressIndicator(color: Color(0xFF003057)) : Column(
                children: [
                  Text(_resultado, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003057))),
                  const Divider(color: Color(0xFF003057)),
                  Text(_tiempoRestante, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF003057))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoticiasPage extends StatelessWidget {
  const NoticiasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003057), // Azul oscuro de fondo
      appBar: AppBar(
        title: const Text("NOTICIAS DEL ÚNICO GRANDE", 
          style: TextStyle(color: Color(0xFFFCB131), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: NewsService().fetchBocaNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFCB131)));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("El robot está buscando noticias...", 
                style: TextStyle(color: Colors.white, fontSize: 16))
            );
          }

          final noticias = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF00457E), // Un azul un poco más claro para la tarjeta
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFFFCB131), width: 0.5), // Borde finito amarillo
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFCB131),
                    child: Icon(Icons.bolt, color: Color(0xFF003057)), // Icono de rayo (noticia flash)
                  ),
                  title: Text(
                    noticias[index]['titulo'] ?? 'Sin título', 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      fontSize: 16,
                    )
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      noticias[index]['subtitulo'] ?? '', 
                      style: const TextStyle(color: Colors.white70, fontSize: 13)
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFCB131), size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}