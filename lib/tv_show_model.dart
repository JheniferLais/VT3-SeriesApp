import 'package:app3_series_api/tv_show_service.dart';
import 'package:flutter/material.dart';

class TvShow {
  int id;
  String imageUrl;
  String name;
  String webChannel;
  double rating;
  String summary;

  TvShow({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.webChannel,
    required this.rating,
    required this.summary,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      imageUrl: json['image']?['medium'] ?? 'N/A',
      name: json['name'],
      webChannel: json['webChannel']?['name'] ?? 'N/A',
      rating: json['rating']?['average']?.toDouble() ?? 0.0,
      summary: json['summary'] ?? 'Sem resumo disponivel',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'webChannel': webChannel,
      'rating': rating,
      'summary': summary,
    };
  }
}

class TvShowModel extends ChangeNotifier {
 late final TvShowService _tvShowService;

 TvShowModel() {
   _tvShowService = TvShowService();
   initialize();
 }

 // Estado das séries favoritas
 List<TvShow> _favTvShows = [];
 bool _isLoading = false;
 String? _errorMessage;

 List<TvShow> get favTvShows => _favTvShows;
 bool get isLoading => _isLoading;
 String? get errorMessage => _errorMessage;
 bool get hasFavorites => _favTvShows.isNotEmpty;

 Future<void> initialize() async {
   await load();
 }

 void _setLoading(bool value) {
   _isLoading = value;
   notifyListeners();
 }

 void _setErrorMessage(String? message) {
   _errorMessage = message;
   notifyListeners();
 }

  Future<void> load() async {
    try {
      _setLoading(true);
      _setErrorMessage(null);
      _favTvShows = await _tvShowService.getAll();
    } catch (e) {
      _setErrorMessage('Falha ao carregar dados: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addToFavorites(TvShow favTvShow) async {
   await _tvShowService.insert(favTvShow);
   notifyListeners();
  }

  Future<void> removeFromFavorites(TvShow favTvShow) async {
    await _tvShowService.delete(favTvShow.id as TvShow);
    _favTvShows.removeWhere((show) => show.id == favTvShow.id);
    notifyListeners();
  }

  Future<bool> isFavorite(TvShow tvShow) async {
   try {
     return await _tvShowService.isFavorite(tvShow);
   } catch (e) {
     _setErrorMessage('Falha em verificar se é favorita: ${e.toString()}');
     return false;
   }
  }

  // ORDENAÇAO
  void sortByRatingAscending() {
    _favTvShows.sort((a, b) => a.rating.compareTo(b.rating));
    notifyListeners();
  }

  void sortByRatingDescending() {
    _favTvShows.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  void sortByNameAscending() {
    _favTvShows.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
  }

  void sortByNameDescending() {
    _favTvShows.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    notifyListeners();
  }

  // API
  Future<List<TvShow>> searchTvShows(String query) async {
    try {
      return await _tvShowService.fetchTvShows(query);
    } catch (e) {
      throw Exception('Falha ao buscar séries: ${e.toString()}');
    }
  }

  Future<TvShow> getTvShowById(int id) async {
    try {
      return await _tvShowService.fetchTvShowById(id);
    } catch (e) {
      throw Exception('Falha ao buscar série por id: ${e.toString()}');
    }
  }

  // LOCAL
 void addTvShow(TvShow tvShow, BuildContext context) {
   favTvShows.add(tvShow);
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(
         'Série adicionada com sucesso!',
         textAlign: TextAlign.center,
       ),
       duration: Duration(seconds: 2),
     ),
   );
   notifyListeners();
 }

 void removeTvShow(TvShow tvShow, BuildContext context) {
   final index = favTvShows.indexWhere(
         (show) => show.name.toLowerCase() == tvShow.name.toLowerCase(),
   );
   favTvShows.removeAt(index);
   ScaffoldMessenger.of(context).clearSnackBars();
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('${tvShow.name} excluída!'),
       duration: Duration(seconds: 3),
       action: SnackBarAction(
         label: 'DESFAZER',
         onPressed: () {
           favTvShows.insert(index, tvShow);
           notifyListeners();
         },
       ),
     ),
   );
   notifyListeners();
 }

 void editTvShow(TvShow oldTvShow, TvShow newTvShow, BuildContext context) {
   final index = favTvShows.indexOf(oldTvShow);
   favTvShows[index] = newTvShow;
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('Série ${index + 1} atualizada!'),
       duration: Duration(seconds: 2),
     ),
   );
   notifyListeners();
 }
}
