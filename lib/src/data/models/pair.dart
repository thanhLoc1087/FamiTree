class Pair<T1 extends num, T2 extends num> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);

  Pair operator +(Pair<T1, T2> pair) {
    return Pair(a + pair.a, b + pair.b);
  }

  @override
  String toString() {
    return "{$a : $b}";
  }
}
