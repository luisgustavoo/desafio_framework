class PaginationFilter {
  PaginationFilter({
    required this.offset,
    required this.limit,
  });

  late int offset;
  late int limit;

  @override
  String toString() {
    return 'PaginationFilter{offset: $offset, limit: $limit}';
  }
}
