window.UserPassportView = Backbone.View.extend({
  tagName: "li",
  className: "user",

  events: {
    "mouseenter": "show",
    "mouseleave": "hide"
  },

  initialize: function(opts) {
    this.$passport = $(".passport", this.el);
    this.useTemplate('users','_user_passport');
    this.model.bind("change", this.render, this);
  },

  render: function() {
    return this;
  },

  show: function() {
    this.$passport.html( Mustache.to_html(this.tmpl, this.model.toJSON()));
    $(".activity", this.$passport).html(this.options.activity["action"]).addClass(this.options.activity["action"])
    this.$passport.fadeIn('fast');
  },

  hide: function() {
    this.$passport.fadeOut('fast');
  }

});
