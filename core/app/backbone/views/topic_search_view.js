window.TopicSearchView = Backbone.View.extend({
  tagName: "div",
  className: "topic-block",

  tmpl: Template.use("topics", "_topic_search"),

  render: function() {
    this.$el.html( this.tmpl.render( this.model.toJSON()) );

    return this;
  },

});
