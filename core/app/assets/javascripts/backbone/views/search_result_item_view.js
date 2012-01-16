(function() {
window.SearchResultItemView = function SearchResultItemView(opts) {
  if (opts.model.get("the_class") === "FactData") {
    return new FactView({model: new Fact(opts.model.get('the_object'))});
  } else {
    return new UserView({model: new User(opts.model.get('the_object'))});
  }
}
})();