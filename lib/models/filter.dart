import 'dart:math';


class LowPassFilter {
  final double cutoffFrequency;
  final double samplingRate;
  final int order;

  late List<double> _b, _a;

  LowPassFilter(this.cutoffFrequency, this.samplingRate, this.order) {
    final nyquist = 0.5 * samplingRate;
    final normalCutoff = cutoffFrequency / nyquist;
    _b = List.filled(order + 1, 0);
    _a = List.filled(order + 1, 0);

    final k = tan(pi * normalCutoff);
    final q = sqrt(2.0 - pow(2.0, 1.0 / (order + 1)));
    _a[0] = (pow(k, order) * pow(q, order - 1)).toDouble();
    _b[0] = 1;

    for (int i = 1; i <= order; i++) {
      _a[i] = _a[0];
      _b[i] = ((order - i + 1) *
              pow(k, order - i) *
              comb(order, i) *
              pow(q, order - i - 1))
          .toDouble();
    }

    final a0Inv = 1.0 / _a[0];
    for (int i = 0; i <= order; i++) {
      _a[i] *= a0Inv;
      _b[i] *= a0Inv;
    }
  }

  List<double> process(List<double> data) {
    return filter(_b, _a, data);
  }

  int comb(int n, int k) {
    if (k < 0 || k > n) {
      return 0;
    }
    if (k == 0 || k == n) {
      return 1;
    }
    k = min(k, n - k);
    int result = 1;
    for (int i = 1; i <= k; i++) {
      result = (result * (n - i + 1)) ~/ i;
    }
    return result;
  }
  List<double> filter(List<double> b, List<double> a, List<double> data) {
    final result = List<double>.filled(data.length, 0);
    final na = max(a.length, b.length);
    final nfilt = b.length;
    final nfact = 3 * (nfilt - 1);

    final paddedData =
        List<double>.filled(nfact, 0) + data + List<double>.filled(nfact, 0);
    final y = List<double>.filled(paddedData.length, 0);

    for (int i = 0; i < paddedData.length; i++) {
      for (int j = 0; j < na; j++) {
        if (i - j < 0) {
          continue;
        }

        if (j < nfilt) {
          y[i] += b[j] * paddedData[i - j];
        }
        if (j > 0) {
          y[i] -= a[j] * y[i - j];
        }
      }
    }

    result.setAll(0, y.sublist(nfact, data.length + nfact));

    return result;
  }
}
