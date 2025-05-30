import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'escaneo_rapido.dart';

class LectorCodigoBarrasPage extends StatefulWidget {
  const LectorCodigoBarrasPage({super.key});

  @override
  State<LectorCodigoBarrasPage> createState() => _LectorCodigoBarrasPageState();
}

class _LectorCodigoBarrasPageState extends State<LectorCodigoBarrasPage> {
  late MobileScannerController controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(String? barcode) {
    if (!_isScanning || barcode == null) return;
    
    setState(() => _isScanning = false);
    controller.stop();
    
    // Aquí podrías hacer una llamada a tu API con el código de barras
    // para obtener la información del producto antes de navegar
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EscaneoRapidoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color accentColor = const Color(0xFF5A99D6);
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lector código de barras',
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: textColor,
                );
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      _onBarcodeDetected(barcode.rawValue);
                    }
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accentColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  margin: const EdgeInsets.all(50),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EscaneoRapidoPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A99D6).withOpacity(0.3),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Confirmar escaneo',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 