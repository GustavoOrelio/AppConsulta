class SearchResult {
  final String title;
  final String link;

  SearchResult({required this.title, required this.link});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['titulo'] as String? ?? 'Título Padrão',
      link: json['link'] as String? ?? 'http://example.com',
    );
  }
}
