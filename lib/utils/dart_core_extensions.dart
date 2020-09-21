
extension IterableExtensions<T> on Iterable<T> {
  T firstOrNull() {
    return this.isEmpty ? null : this.first;
  }
}

extension MapExtensions<K,V> on Map<K,V> {

  /// An alias for the Map index operator to allow null coalescing.
  V valueFor(K k) => this[k];

}