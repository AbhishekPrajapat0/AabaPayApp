/* Tushar Ugale * Technicul.com */
abstract class TransactionsEvent {}

class TransactionsLoadEvent extends TransactionsEvent {}

class SearchTransactionsEvent extends TransactionsEvent {
  String searchQuery;
  SearchTransactionsEvent(this.searchQuery);
}

class TransactionsFilterEvent extends TransactionsEvent {
  String filterValue;
  TransactionsFilterEvent(this.filterValue);
}
