import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onSelectImage;

  const ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  // --- Cor do Botão (Rosa) ---
  final Color _buttonColor = const Color(0xFFFC7ACF);

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    widget.onSelectImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ajuste de Estilo: Caixa de pré-visualização
        Container(
          width: double.infinity,
          height: 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), // Borda quadrada
            // Fundo sutil para combinar com os TextFields
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              width: 1,
              // Borda branca para combinar com os TextFields
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              // Ajuste de Estilo: Placeholder com ícone e texto branco
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhuma Imagem!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 10),
        // Ajuste de Estilo: Botões com tema
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text('Câmera'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor, // Cor rosa
                  foregroundColor: Colors.black, // Texto preto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Quadrado
                  ),
                  minimumSize: const Size(0, 45), // Altura fixa
                ),
                onPressed: () => _takePicture(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('Galeria'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor, // Cor rosa
                  foregroundColor: Colors.black, // Texto preto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Quadrado
                  ),
                  minimumSize: const Size(0, 45), // Altura fixa
                ),
                onPressed: () => _takePicture(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}