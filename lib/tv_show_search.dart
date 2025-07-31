import 'package:app3_series_api/tv_show_grid.dart';
import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TvShowSearchScreen extends StatefulWidget {
  const TvShowSearchScreen({super.key});

  @override
  State<TvShowSearchScreen> createState() => _TvShowSearchScreenState();
}

class _TvShowSearchScreenState extends State<TvShowSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  Future<List<TvShow>>? searchResults = Future.value([]);

  bool onSubmit = false;

  void submit() {
    if (_formKey.currentState!.validate()) {
      final tvShowModel = context.read<TvShowModel>();
      setState(() {
        onSubmit = true;
        searchResults = tvShowModel.searchTvShows(_searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Buscar Series',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: submit,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, digite o nome da série';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          onSubmit
              ? Expanded(
            child: FutureBuilder<List<TvShow>>(
              future: searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            "Ocorreu um erro: ${snapshot.error}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: () => context.go("/"),
                            child: const Text("Voltar"),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (onSubmit &&
                    (!snapshot.hasData || snapshot.data!.isEmpty)) {
                  return const Center(
                    child: Text(
                      "Nenhum resultado encontrado",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        '${snapshot.data!.length} resultados encontrados',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TvShowGrid(tvShows: snapshot.data!),
                      ),
                    ],
                  );
                }
              },
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
