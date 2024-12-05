import 'package:responsi_124220082_lenansyaersas/network/base_network.dart';

abstract class AmiiboDetailView {
  void showLoading();
  void hideLoading();
  void showDetailData(Map<String, dynamic> detailData);
  void showError(String message);
}

class AmiiboDetailPresenter {
  final AmiiboDetailView view;
  AmiiboDetailPresenter(this.view);

  Future<void> loadDetailData(String endpoint, int id) async {
    view.showLoading();
    try {
      final data = await BaseNetwork.getDetailData(endpoint, id);
      view.showDetailData(data);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}