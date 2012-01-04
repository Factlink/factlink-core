window.FactRelationView = Backbone.View.extend({
  tagName: "li",
  className: "fact-relation",

  initialize: function() {
    this.model.bind('destroy', this.remove, this);
  },

  remove: function() {
    $(this.el).fadeOut('fast', function() {
      $(this.el).remove();
    });
  },

  render: function() {
    $(this.el).html(this.model.get("displaystring"));

    return this;
  }
});