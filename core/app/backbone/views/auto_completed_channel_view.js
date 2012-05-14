window.AutoCompletedChannelView = Backbone.View.extend({
  tagName: "li",

  events: {
    "mouseenter": "mouseEnter"
  },

  tmpl: HoganTemplates["channels/_auto_completed_channel"],

  initialize: function () {
    this.queryRegex = new RegExp(this.options.query, "gi");
  },

  render: function () {
    var title = this.model.get('title');
    var highlightedTitle = title.replace(this.queryRegex, "<em>$&</em>");

    var context = _.extend(this.model.toJSON(), {
      highlightedTitle: highlightedTitle
    });

    if ( this.model.get('user_channel' ) ) {
      this.$el.addClass('user-channel');
    }

    this.$el.html( this.tmpl.render( context ) );

    return this;
  },

  activate: function () {
    this.$el.addClass('active');
  },

  deActivate: function () {
    this.$el.removeClass('active');
  },

  mouseEnter: function (e) {
    this.options.parent.activateAutoCompleteView(this);
  }
});
