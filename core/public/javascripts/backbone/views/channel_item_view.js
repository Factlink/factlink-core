window.ChannelItemView = Backbone.View.extend({
  tagName: "li",
  
  events: {
    "click" : "clickHandler"
  },
  
  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
  },
  
  render: function() {
    this.$( this.el )
      .html( $.mustache($('#channel_li').html(), this.model.toJSON() ))
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
  
  clickHandler: function( e ) {
    Router.navigate(Router.getUsername() + "/channels/" + this.model.id + "/facts", true);

    this.model.set({new_facts: false});
    
    e.preventDefault();
  }
});
