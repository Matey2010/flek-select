class SelectOption<T, P> {
  final String text;
  final T value;
  final P? params;

  const SelectOption({required this.text, required this.value, this.params});
}
