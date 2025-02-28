import 'package:flutter/material.dart';
import 'package:my_app/models/pokemon_details_model.dart';
import 'package:my_app/services/pokedex_service.dart';
import 'package:my_app/utils/strings.dart';
import 'package:my_app/widgets/custom_image.dart';
import 'package:my_app/widgets/evolution_section.dart';

class PokemonDetailsPage extends StatelessWidget {
  final String name;
  const PokemonDetailsPage({
    super.key,
    required this.name,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PokedexService().getPokemonDetails(name),
      initialData: const {},
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        PokemonDetails pokemonDetails = snapshot.data;
        return Scaffold(
            appBar: AppBar(
              title: Text(
                capitalizeString(pokemonDetails.name!),
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            backgroundColor: pokemonDetails.bgColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImage(
                        image:
                            pokemonDetails.sprites!.other!.home!.frontDefault!),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                capitalizeString(pokemonDetails.name!),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Divider(
                              height: 2.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'No.: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${pokemonDetails.id}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tipo: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ...pokemonDetails.types!
                                    .map((e) => Text(
                                          '${capitalizeString(e.type!.name!)} ',
                                        ))
                                    .toList()
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Altura: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${pokemonDetails.height}dm'),
                                const SizedBox(
                                  width: 25.0,
                                ),
                                const Text(
                                  'Peso: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${pokemonDetails.weight}hg'),
                              ],
                            ),
                            Row(children: [
                              const Text(
                                'EXP: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(pokemonDetails.baseExperience.toString()),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    EvolutionSection(pokemonName: pokemonDetails.name!),
                    const SizedBox(
                      height: 15.0,
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
