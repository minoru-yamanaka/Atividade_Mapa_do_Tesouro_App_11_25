import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foto/models/place.dart';
import 'package:foto/providers/greate_places.dart';
import 'package:foto/widgets/image_input.dart';
import 'package:foto/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _nomeRuaController = TextEditingController(); // <-- ADICIONADO
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();

  File? _pickedImage;
  PlaceLocation? _pickedLocation; // Guarda Lat/Lng

  void _selectImage(File image) {
    _pickedImage = image;
  }

  void _selectLocation(PlaceLocation location) {
    _pickedLocation = location;
  }

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha o Título, a Imagem e a Localização.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // <-- LÓGICA ATUALIZADA -->
    final completeLocation = PlaceLocation(
      latitude: _pickedLocation!.latitude,
      longitude: _pickedLocation!.longitude,
      address: _pickedLocation!.address,
      nomeRua: _nomeRuaController.text, // <-- ADICIONADO
      cep: _cepController.text,
      numero: _numeroController.text,
    );

    Provider.of<GreatePlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
      completeLocation,
      _noteController.text,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Lugar')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 10),

                    // <-- CAMPO ADICIONADO -->
                    TextField(
                      controller: _nomeRuaController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Rua',
                      ),
                    ),

                    // <-- FIM DA ADIÇÃO -->
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _cepController,
                            decoration: const InputDecoration(labelText: 'CEP'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _numeroController,
                            decoration: const InputDecoration(labelText: 'Nº'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Nota'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ImageInput(_selectImage),
                    const SizedBox(height: 20),
                    LocationInput(_selectLocation),
                  ],
                ),
              ),
            ),
          ),

          // Ajuste: Trocado para ElevatedButton para ter fundo sólido
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
            style: ElevatedButton.styleFrom(
              // Ajuste: Cor de fundo (sintaxe corrigida)
              backgroundColor: Colors.deepPurpleAccent,
              // Adicionado para contraste
              foregroundColor: Colors.white,
              // Ajuste: Botão quadrado
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              // Ajuste: Largura total e altura fixa
              minimumSize: const Size(double.infinity, 50),
              // minimumSize: const Size(5, 20),
            ),
            onPressed: _submitForm,
          ),

          // ElevatedButton.icon(
          //   icon: const Icon(Icons.add),
          //   label: const Text('Adicionar'),
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: Colors.black,
          //     // backgroundColor: Theme.of(context).colorScheme.secondary,
          //     elevation: 0,
          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   ),
          //   onPressed: _submitForm,
          // ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
