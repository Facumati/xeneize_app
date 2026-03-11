import 'package:flutter/material.dart';

void main() => runApp(XeneizeApp());

class XeneizeApp extends StatelessWidget {
  const XeneizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xeneize App',
      theme: ThemeData(
        // El azul y oro oficial de nuestra pasión
        primaryColor: const Color(0xFF003087),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Un gris clarito de fondo
      appBar: AppBar(
        title: const Text('XENEIZE APP', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: const Color(0xFF003087), // Azul
        centerTitle: true,
        elevation: 10,
      ),
      body: SingleChildScrollView( // Por si hay muchas noticias
        child: Column(
          children: [
            // --- TARJETA PRÓXIMO PARTIDO ---
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFDB913), // Oro
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  const Text("PRÓXIMO PARTIDO vs river", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003087))),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.shield, size: 50, color: Color(0xFF003087)), // Simula escudo Boca
                      const Text("VS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Icon(Icons.shield_outlined, size: 50, color: Colors.black54), // Simula Rival
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("BOCA vs RIVAL", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003087))),
                  const Text("Domingo - 21:00 hs", 
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                ],
              ),
            ),

            // --- SECCIÓN DE NOTICIAS ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text("NOTICIAS DE HOY", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003087)))
              ),
            ),

            // Noticia 1
            cardNoticia("Formación confirmada para el domingo", "Hace 10 minutos"),
            // Noticia 2
            cardNoticia("Entrenamiento en Ezeiza: Novedades del plantel", "Hace 2 horas"),
          ],
        ),
      ),
    );
  }

  // Esto es una función para no repetir código (un "componente")
  Widget cardNoticia(String titulo, String tiempo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.newspaper, color: Color(0xFFFDB913)),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(tiempo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}