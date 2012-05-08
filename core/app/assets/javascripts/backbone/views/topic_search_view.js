window.TopicSearchView = Backbone.View.extend({
  tagName: "div",
  className: "topic-block",



  initialize: function() {
    this.useTemplate("topics", "_topic_search");
  },

  render: function() {
    this.$el.html( this.tmpl.render( this.model.toJSON()) );

    return this;
  },

});
