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

  templateHelpers: function(){
    var view = this
    return {
      highlightedTitle: function(){return this.title.replace(view.queryRegex, "<em>$&</em>");}
    };
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
