class GlobalObject<I, V> {
  GlobalObject({
    required this.id,
    this.value,
  });

  factory GlobalObject.fromJson(Map<String, dynamic> json) => GlobalObject(
        id: json['id'] as I,
        value: json['value'] as V?,
      );
  I id;
  V? value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
