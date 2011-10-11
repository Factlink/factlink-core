window.ChannelMenuView = Backbone.View.extend({
  tagName: "li",
  template: _.template($('#channel_li').html()),
  
  events: {
    // @TODO: Backbone router should catch these url changes, but no URL seems to match. Look in to this later please.
    "click" : "showFacts"
  },
  
  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
  },
  
  render: function() {
    this.$( this.el )
      .html( this.template( {
        channel: this.model.toJSON(),
        username: Router.getUsername()
      } ) )
      .attr('id', 'channel-' + this.model.id);
    return this;
  },
  
  setActive: function() {
    this.$( this.el ).addClass('active');
  },
  
  setNotActive: function() {
    this.$( this.el ).removeClass('active');
  },
  
  setLoading: function() {
    this.$( this.el ).addClass('loading');
  },
  
  stopLoading: function() {
    this.$( this.el ).removeClass('loading');
  },
  
  remove: function() {
    this.$( this.el ).remove();
  },
  
  showFacts: function( e ) {
    Router.navigate(Router.getUsername() + "/channels/" + this.model.id + "/facts", true);
    
    e.preventDefault();
  }
});