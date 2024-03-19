import 'dart:math' as math;

extension MinMax on Iterable<num> {
  double get min => reduce(math.min).toDouble();
  double get max => reduce(math.max).toDouble();
}