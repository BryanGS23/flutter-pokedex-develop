import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EvolutionSection extends StatefulWidget {
  final String pokemonName;

  const EvolutionSection({Key? key, required this.pokemonName})
      : super(key: key);

  @override
  _EvolutionSectionState createState() => _EvolutionSectionState();
}

class _EvolutionSectionState extends State<EvolutionSection> {
  List<String> evolutionChain = [];

  @override
  void initState() {
    super.initState();
    fetchEvolutionChain(widget.pokemonName);
  }

  Future<void> fetchEvolutionChain(String name) async {
    try {
      var response =
          await Dio().get('https://pokeapi.co/api/v2/pokemon-species/$name');
      var evolutionUrl = response.data['evolution_chain']['url'];
      var evolutionResponse = await Dio().get(evolutionUrl);

      List<String> chain = [];
      var chainData = evolutionResponse.data['chain'];

      while (chainData != null) {
        chain.add(chainData['species']['name']);
        chainData = chainData['evolves_to'].isNotEmpty
            ? chainData['evolves_to'][0]
            : null;
      }

      setState(() {
        evolutionChain = chain;
      });
    } catch (e) {
      print('Error fetching evolution chain: $e');
    }
  }

  Future<int> getPokemonId(String name) async {
    try {
      var response = await Dio().get('https://pokeapi.co/api/v2/pokemon/$name');
      return response.data['id'];
    } catch (e) {
      print('Error obteniendo el ID del Pokémon: $e');
      return 0; // En caso de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Evoluciones:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        evolutionChain.isEmpty
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: evolutionChain
                    .map((evo) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              FutureBuilder<int>(
                                future: getPokemonId(evo),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.data == 0) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Image.network(
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${snapshot.data}.png',
                                    height: 80,
                                  );
                                },
                              ),
                              Text(evo, style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}
