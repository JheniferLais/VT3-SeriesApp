import 'package:app3_series_api/tv_show_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TvShowGrid extends StatefulWidget {
  const TvShowGrid({super.key, required this.tvShows});

  final List<TvShow> tvShows;

  @override
  State<TvShowGrid> createState() => _TvShowGridState();
}

class _TvShowGridState extends State<TvShowGrid> {
  @override
  Widget build(BuildContext context) {
    final tvShowModel = context.watch<TvShowModel>();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemCount: widget.tvShows.length,
      itemBuilder: (context, index) {
        final tvShow = widget.tvShows[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () => context.go('/tv_show/${tvShow.id}'),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          tvShow.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                          errorBuilder: (context, child, stackTrace) =>
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Theme.of(context).colorScheme.primary,
                                child: Icon(Icons.error),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(tvShow.name),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Text(
                                tvShow.rating.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tvShowModel.tvShows.any((show) => show.id == tvShow.id)
                ? Positioned(
              child: IconButton(
                onPressed: () =>
                    tvShowModel.removeTvShow(tvShow, context),
                icon: Icon(Icons.favorite, size: 32, color: Colors.red),
              ),
            )
                : Positioned(
              child: IconButton(
                onPressed: () =>
                    tvShowModel.addTvShow(tvShow, context),
                icon: Icon(Icons.favorite_border_sharp, size: 32),
              ),
            ),
          ],
        );
      },
    );
  }
}