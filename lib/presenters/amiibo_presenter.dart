import 'package:responsi_124220082_lenansyaersas/models/amiibo_model.dart';
import 'package:responsi_124220082_lenansyaersas/network/base_network.dart';

abstract class AmiiboView {
  void showLoading();
  void hideLoading();
  void showAmiiboList(List<Amiibo> amiiboList);
  void showError(String message);
}

class AmiiboPresenter {
  final AmiiboView view;
  AmiiboPresenter(this.view);

  Future<void> loadAmiiboData(String endpoint) async {
    try {
      view.showLoading();
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final amiiboList = data.map((json) => Amiibo.fromJson(json)).toList();
      view.showAmiiboList(amiiboList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
