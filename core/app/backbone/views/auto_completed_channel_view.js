window.AutoCompletedChannelView = Backbone.Marionette.ItemView.extend({
  tagName: "li",

  events: {
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"
  },

  template: "channels/_auto_completed_channel",

  initialize: function () {
    this.queryRegex = new RegExp(this.options.query, "gi");
  },

  serializeData: function(){
    var title = this.model.get('title');
    var highlightedTitle = title.replace(this.queryRegex, "<em>$&</em>");

    return _.extend(this.model.toJSON(), {
      highlightedTitle: highlightedTitle
    });

  },

  onRender: function () {
    console.info(this.$el);
    if ( this.model.get('user_channel' ) ) {
      this.$el.addClass('user-channel');
    }
  },

  activate: function () {
    this.$el.addClass('active');
  },

  deActivate: function () {
    this.$el.removeClass('active');
  },

  mouseEnter: function (e) {
    this.options.parent.activateAutoCompleteView(this);
  },

  mouseLeave: function (e) {
    this.options.parent.deActivateAutoCompleteView(this);
  }
});
