import 'package:app3_series_api/custom_drawer.dart';
import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final VoidCallback? onFabPressed;

  const BaseScreen({
    super.key,
    required this.child,
    this.onFabPressed,
  });

  void _openSortingMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Ordenação Crescente'),
              onTap: () {
                context.read<TvShowModel>().sortByRatingAscending();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Ordenação Decrescente'),
              onTap: () {
                context.read<TvShowModel>().sortByRatingDescending();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Eu Amo Séries 🎬')],
        ),
      ),
      drawer: CustomDrawer(),
      body: child,

      // Botão FAB para ordenação nas telas de SEARCH e FAV
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSortingMenu(context),
        tooltip: 'Ordenar por Rating',
        child: Icon(Icons.sort),
      ),
    );
  }
}
