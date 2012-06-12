window.UserPassportView = Backbone.View.extend({
  tagName: "li",
  className: "user",

  events: {
    "mouseenter": "show",
    "mouseleave": "hide"
  },

  tmpl: Template.use("users", "_user_passport"),

  initialize: function(opts) {
    this.$passport = $(".passport", this.el);

    this.model.bind("change", this.render, this);
  },

  show: function() {
    this.$passport.html( this.tmpl.render(this.model.toJSON()));

    $(".activity", this.$passport)
      .html(this.options.activity["internationalized_action"])
      .addClass(this.options.activity["action"]);

    this.$passport.fadeIn('fast');
  },

  hide: function() {
    this.$passport.fadeOut('fast');
  }

});
