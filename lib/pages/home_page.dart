import 'package:flutter/material.dart';
import 'package:responsi_124220082_lenansyaersas/models/amiibo_model.dart';
import 'package:responsi_124220082_lenansyaersas/pages/detail_page.dart';
import 'package:responsi_124220082_lenansyaersas/pages/favorite_page.dart';
import 'package:responsi_124220082_lenansyaersas/presenters/amiibo_presenter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements AmiiboView {
  late AmiiboPresenter _presenter;
  bool _isLoading = false;
  List<Amiibo> _amiiboList = [];
  final List<Amiibo> _favoriteList = [];
  List<bool> _isFavoriteList = [];
  String? _errorMessage;
  final String _endpoint = 'api/amiibo/';
  final Color primaryColor = const Color(0xFFFFBA00);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _presenter = AmiiboPresenter(this);
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _presenter.loadAmiiboData(_endpoint);
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAmiiboList(List<Amiibo> amiiboList) {
    setState(() {
      _amiiboList = amiiboList;
      _isFavoriteList = List<bool>.generate(amiiboList.length, (index) => false);
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _removeFromFavorite(Amiibo amiibo) {
    setState(() {
      _favoriteList.remove(amiibo);
      final index = _amiiboList.indexOf(amiibo);
      if (index != -1) {
        _isFavoriteList[index] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildAmiiboListPage(),
      FavoritePage(
        favoriteAmiibos: _favoriteList,
        onFavoriteRemoved: _removeFromFavorite,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Nintendo Amiibo List" : "Favorite Amiibo",
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Page: Amiibo List
  Widget _buildAmiiboListPage() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          )
        : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error: $_errorMessage",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _amiiboList.length,
                itemBuilder: (context, index) {
                  final amiibo = _amiiboList[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the detail page when an Amiibo is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              amiibo: amiibo,
                              isFavorite: _isFavoriteList[index],
                              onFavoriteToggle: (Amiibo toggledAmiibo) {
                                setState(() {
                                  final toggledIndex =
                                      _amiiboList.indexOf(toggledAmiibo);
                                  if (toggledIndex != -1) {
                                    _isFavoriteList[toggledIndex] =
                                        !_isFavoriteList[toggledIndex];
                                    if (_isFavoriteList[toggledIndex]) {
                                      _favoriteList.add(toggledAmiibo);
                                    } else {
                                      _favoriteList.remove(toggledAmiibo);
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  amiibo.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    amiibo.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Game Series: ${amiibo.gameSeries}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isFavoriteList[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavoriteList[index]
                                    ? Colors.red
                                    : Colors.grey,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFavoriteList[index] =
                                      !_isFavoriteList[index];
                                  if (_isFavoriteList[index]) {
                                    _favoriteList.add(amiibo);
                                  } else {
                                    _favoriteList.remove(amiibo);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
