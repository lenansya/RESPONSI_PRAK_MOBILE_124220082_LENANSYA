import 'package:flutter/material.dart';
import 'package:responsi_124220082_lenansyaersas/models/amiibo_model.dart';

class DetailPage extends StatefulWidget {
  final Amiibo amiibo;
  final bool isFavorite; // Status favorit saat ini
  final Function(Amiibo) onFavoriteToggle; // Callback untuk toggle favorit

  const DetailPage({
    super.key,
    required this.amiibo,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteToggle(widget.amiibo); // Panggil callback untuk memperbarui daftar favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amiibo Details'),
        backgroundColor: const Color(0xFFFFBA00),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 28,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image at the top with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.amiibo.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Amiibo Name
              Center(
                child: Text(
                  widget.amiibo.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Information Section
              buildInfoRow('Amiibo Series:', widget.amiibo.amiiboSeries),
              buildInfoRow('Character:', widget.amiibo.character),
              buildInfoRow('Game Series:', widget.amiibo.gameSeries),
              buildInfoRow('Type:', widget.amiibo.type),
              buildInfoRow('Head:', widget.amiibo.head),
              buildInfoRow('Tail:', widget.amiibo.tail),

              const SizedBox(height: 16),

              // Release Dates Section
              const Text(
                'Release Dates:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              buildInfoRow('Australia:', widget.amiibo.releaseDates["AU"] ?? 'Unknown'),
              buildInfoRow('Europe:', widget.amiibo.releaseDates["EU"] ?? 'Unknown'),
              buildInfoRow('Japan:', widget.amiibo.releaseDates["JP"] ?? 'Unknown'),
              buildInfoRow('North America:', widget.amiibo.releaseDates["NA"] ?? 'Unknown'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build each row with label and value
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
