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
    showModalBottomSheet(context: context, builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Ordenar por Rating (Crescente)'),
              onTap: () {
                context.read<TvShowModel>().sortByRatingAscending();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Ordenar por Rating (Decrescente)'),
              onTap: () {
                context.read<TvShowModel>().sortByRatingDescending();
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Ordenar por Nome (A–Z)'),
              onTap: () {
                context.read<TvShowModel>().sortByNameAscending();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sort_by_alpha_outlined),
              title: Text('Ordenar por Nome (Z–A)'),
              onTap: () {
                context.read<TvShowModel>().sortByNameDescending();
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

      // Botão FAB para ordenação
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSortingMenu(context),
        child: Icon(Icons.sort),
      ),
    );
  }
}
