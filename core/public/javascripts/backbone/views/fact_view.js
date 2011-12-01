window.FactView = Backbone.View.extend({
  tagName: "div",
  className: "fact-block",
  tmpl: $('#fact_tmpl').html(),
  partials: {
    fact_bubble: $('#fact_bubble_tmpl').html(),
    fact_wheel: $('#fact_wheel_tmpl').html()
  },
  initialize: function(e) {
    $(this.el).attr('data-fact-id', this.model.id);
  },
  render: function() {
    $( this.el )
      .html( Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials))
      .factlink();
    
    return this;
  }
});