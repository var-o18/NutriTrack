import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E1E);
    final Color textColor = Colors.white;
    final Color accentColor = const Color(0xFFFFB74D);

    Widget _buildFeatureItem({
      required IconData icon,
      required String title,
      required String subtitle,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildPricingOption({
      required String duration,
      required String price,
      required String billing,
      bool isRecommended = false,
    }) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isRecommended ? accentColor : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              duration,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              billing,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            if (isRecommended)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Ahorra 58%',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Planes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Simplifica tu recorrido con herramientas de registro más rápidas y configuraciones personalizadas',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildPricingOption(
                      duration: '1 mes',
                      price: '9,99 €/mes',
                      billing: 'Facturación mensual',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPricingOption(
                      duration: '12 meses',
                      price: '4,17 €/mes',
                      billing: '49,99 € facturan anualmente',
                      isRecommended: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Con Premium, puedes hacer lo siguiente:',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _buildFeatureItem(
                icon: Icons.block,
                title: 'Sin publicidad',
                subtitle: 'Enfócate en tu recorrido',
              ),
              _buildFeatureItem(
                icon: Icons.qr_code_scanner,
                title: 'Registra los alimentos más rápido',
                subtitle: 'Con el código de barras y el registro de varios días a la vez, todo es más fácil',
              ),
              _buildFeatureItem(
                icon: Icons.settings,
                title: 'Personaliza tus objetivos',
                subtitle: 'Configuraciones flexibles de calorías y macros',
              ),
              _buildFeatureItem(
                icon: Icons.timer,
                title: 'Haz un seguimiento de tu ayuno intermitente',
                subtitle: 'El momento del día en el que comes también importa',
              ),
              _buildFeatureItem(
                icon: Icons.download,
                title: 'Descarga los informes de progreso',
                subtitle: 'Comparte tus datos con un entrenador o un médico',
              ),
              _buildFeatureItem(
                icon: Icons.support_agent,
                title: 'Obtén soporte al cliente prioritario',
                subtitle: 'Respuestas rápidas de nuestro amigable equipo',
              ),
              const SizedBox(height: 16),
              Text(
                'Además, todo lo que incluye el plan gratuito:',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _buildFeatureItem(
                icon: Icons.restaurant,
                title: 'Registro de alimentos y actividad física',
                subtitle: '',
              ),
              _buildFeatureItem(
                icon: Icons.trending_up,
                title: 'Seguimiento del progreso',
                subtitle: '',
              ),
              _buildFeatureItem(
                icon: Icons.info,
                title: 'Información sobre nutrición',
                subtitle: '',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Comenzar prueba gratis de 30 días',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'La facturación comienza al final de tu prueba gratuita a menos que canceles. Los planes se renuevan automáticamente. Cancelar a través de la App Store.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
} 