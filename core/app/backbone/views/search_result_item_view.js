(function() {
  window.getSearchResultItemView = function SearchResultItemView(opts) {
    if (opts.model.get("the_class") === "FactData") {
      return new FactView({model: new Fact(opts.model.get('the_object'))});
    } else if (opts.model.get("the_class") === "User") {
      return new UserSearchView({model: new User(opts.model.get('the_object'))});
    } else if (opts.model.get("the_class") === "Topic") {
      return new TopicSearchView({model: new Topic(opts.model.get('the_object'))});
    } else {
      console.info("Unknown class of searchresult: ",opts.model.get('the_class'));
      return undefined;
    }
  };
})();