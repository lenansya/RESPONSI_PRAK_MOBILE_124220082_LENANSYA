import 'package:flutter/material.dart';
import 'package:responsi_124220082_lenansyaersas/models/amiibo_model.dart';

class FavoritePage extends StatefulWidget {
  final List<Amiibo> favoriteAmiibos;
  final Function(Amiibo) onFavoriteRemoved; // Callback untuk menghapus dari favorit

  const FavoritePage({
    super.key,
    required this.favoriteAmiibos,
    required this.onFavoriteRemoved,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Amiibo> _favoriteAmiibos;

  @override
  void initState() {
    super.initState();
    _favoriteAmiibos = widget.favoriteAmiibos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _favoriteAmiibos.isEmpty
          ? Center(
              child: Text(
                "No favorites yet!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteAmiibos.length,
              itemBuilder: (context, index) {
                final amiibo = _favoriteAmiibos[index];

                return Dismissible(
                  key: Key(amiibo.head), // Unique key for each item
                  direction: DismissDirection.endToStart, // Swipe left to delete
                  onDismissed: (direction) {
                    setState(() {
                      _favoriteAmiibos.removeAt(index);
                    });

                    widget.onFavoriteRemoved(amiibo); // Memanggil callback

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${amiibo.character} removed from favorites'),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
