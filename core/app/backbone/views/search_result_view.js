window.SearchResultView = Backbone.Factlink.CompositeView.extend({
  tagName: "div",
  className: "search-results",

  template: "search_results/_search_results",

  itemViewContainer: '.results',

  buildItemView: function(item, itemView) {
    debugger;
    var itemViewOptions = _.result(this, "itemViewOptions");
    var options = _.extend({model: item}, itemViewOptions);

    var view = getSearchResultItemView(options);
    return view
  },


  emptyViewOn: function() {
    this.$el.find('div.no_results').show();
  },

  emptyViewOff: function() {
    this.$el.find('div.no_results').hide();
  }

});