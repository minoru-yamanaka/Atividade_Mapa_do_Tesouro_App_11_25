import 'package:flutter/material.dart';
import 'package:foto/providers/greate_places.dart';
import 'package:foto/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Lugares'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.placeForm);
            },
          ),
        ],
      ),
      body: Consumer<GreatePlaces>(
        child: const Center(child: Text('Nenhum local cadastrado!')),
        builder: (context, greatePlaces, ch) => greatePlaces.itemsCount == 0
            ? ch!
            : ListView.builder(
                itemCount: greatePlaces.itemsCount,
                itemBuilder: (context, i) {
                  final place = greatePlaces.itemByIndex(i);

                  // <-- LÓGICA ATUALIZADA -->
                  final note = place.note ?? 'Sem nota';
                  final rua = place.location?.nomeRua ?? 'Rua não informada';
                  final numero = place.location?.numero ?? 'S/N';
                  final cep = place.location?.cep ?? '';

                  // Formata a linha do endereço
                  String endereco = '$rua, $numero';
                  if (cep.isNotEmpty) {
                    endereco += ' - CEP $cep';
                  }

                  final subtitleText = '$note\n$endereco';
                  // <-- FIM DA ATUALIZAÇÃO -->

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(place.image),
                    ),
                    title: Text(place.title),
                    subtitle: Text(subtitleText),
                    isThreeLine: true,
                    onTap: () {},
                  );
                },
              ),
      ),
    );
  }
}
