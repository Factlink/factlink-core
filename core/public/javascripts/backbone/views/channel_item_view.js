window.ChannelItemView = Backbone.View.extend({
  tagName: "li",
  tmpl: $('#channel_li').html(),
  
  events: {
    "click" : "clickHandler"
  },
  
  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);
    this.model.bind('loading', this.setLoading, this);
    this.model.bind('loaded', this.stopLoading, this);
    this.model.bind('activate', this.setActive, this);
    this.model.bind('deactivate', this.setNotActive, this);
    
    // The model can already be set active before the view has rendered
    if ( this.model.isActive ) {
      this.setActive();
    }
  },
  
  render: function() {
    this.$( this.el )
      .html( $.mustache(this.tmpl, this.model.toJSON() ))
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
    // Nasty fix, previously we used triggerRoute = true here, to make sure the 
    // route gets triggered, but somehow this called the Router twice.
    // @TODO read-later: http://lostechies.com/derickbailey/2011/08/28/dont-execute-a-backbone-js-route-handler-from-your-code/
    Router.navigate(Router.getUsername() + "/channels/" + this.model.id);
    Router.getChannelFacts(Router.getUsername(), this.model.id);

    this.model.set({new_facts: false});
    
    e.preventDefault();
    
    return false;
  }
});
