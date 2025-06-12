import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../data/models/alimneto_model.dart';
import 'escaneo_rapido.dart';
import '../../../data/services/alimentos_service.dart';

class LectorCodigoBarrasPage extends StatefulWidget {
  const LectorCodigoBarrasPage({super.key});

  @override
  State<LectorCodigoBarrasPage> createState() => _LectorCodigoBarrasPageState();
}

class _LectorCodigoBarrasPageState extends State<LectorCodigoBarrasPage> {
  late MobileScannerController controller;
  bool _isScanning = true;
  bool _isLoading = false; // Added for loading state
  final AlimentoService _alimentoService = AlimentoService(); // Instantiate AlimentoService

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

  Future<void> _onBarcodeDetected(String? barcode) async { // Changed to Future<void> and async
    if (!_isScanning || barcode == null || barcode.isEmpty) return;
    
    setState(() {
      _isScanning = false;
      _isLoading = true; // Start loading
    });
    controller.stop();
    
    try {
      Alimento? alimento = await _alimentoService.getAlimentoByCodigoBarras(barcode);

      if (mounted) {
        if (alimento != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EscaneoRapidoPage(scannedAlimento: alimento), // Placeholder
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alimento no encontrado o error de API.')),
          );
          setState(() {
            _isScanning = true;
            _isLoading = false; // Stop loading
          });
          controller.start();
        }
      }
    } catch (e) {
      print("Error in _onBarcodeDetected: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar el código de barras: $e')),
        );
        setState(() {
          _isScanning = true;
          _isLoading = false; // Stop loading
        });
        controller.start();
      }
    }
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
              alignment: Alignment.center, // Center loading indicator
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
                if (_isLoading) // Show loading indicator
                  CircularProgressIndicator(color: accentColor),
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