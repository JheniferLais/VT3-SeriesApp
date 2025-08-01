import 'dart:convert';

import 'package:app3_series_api/database_service.dart';
import 'package:app3_series_api/tv_show_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:sqflite/sqflite.dart';


class TvShowService {

  late final DatabaseService _databaseService = DatabaseService();

  Future<List<TvShow>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('tv_shows');
    return _convertMapsToTvShows(maps);
  }

  List<TvShow> _convertMapsToTvShows(List<Map<String, dynamic>> maps) {
    return maps.map((map) => TvShow(
      id: map['id'] as int,
      imageUrl: map['imageUrl'] as String? ?? '',
      name: map['name'] as String? ?? 'Desconhecido',
      webChannel: map['webChannel'] as String? ?? 'N/A',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      summary: map['summary'] as String? ?? 'Sem resumo disponível',
    )).toList();
    //return maps.map((map) => TvShow.fromJson(map)).toList();
  }

  Future<void> insert(TvShow favTcShow) async {
    final db = await _databaseService.database;
    await db.insert('tv_shows', favTcShow.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(TvShow favTcShow) async {
    final db = await _databaseService.database;
    await db.delete(
        'tv_shows',
        where: 'id = ?',
        whereArgs: [favTcShow.id]
    );
  }

  Future<bool> isFavorite(TvShow tvShow) async {
    final tvShows = await getAll();
    return tvShows.any((show) => show.id == tvShow.id);
  }

  Future<List<TvShow>> fetchTvShows(String query) async {
    final response = await http.get(Uri.parse("https://api.tvmaze.com/search/shows?q=$query"));

    if(response.statusCode == 200) {
      final List<TvShow> tvShows = [];
      json.decode(response.body).forEach((item) {
        tvShows.add(TvShow.fromJson(item['show']));
      });
      return tvShows;
    } else {
      log("Falha ao buscar séries");
      throw Exception("Falha ao buscar séries");
    }
  }

  Future<TvShow> fetchTvShowById(int id) async {
    final response = await http.get(Uri.parse("https://api.tvmaze.com/shows/$id"));

    if (response.statusCode == 200) {
      return TvShow.fromJson(json.decode(response.body));
    } else {
      log("Falha ao buscar série por ID");
      throw Exception("Falha ao buscar série por ID");
    }
  }

}