window.SubchannelItemView = Backbone.View.extend({
  tagName: "li",
  tmpl: $('#subchannel_li').html(),
  
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
      .html( $.mustache(this.tmpl, this.model.toJSON() ))
      .attr('id', 'subchannel-' + this.model.id);
    return this;
  },

  remove: function() {
    this.$( this.el ).remove();
  },
  
  clickHandler: function( e ) {
    // Nasty fix, previously we used triggerRoute = true here, to make sure the 
    // route gets triggered, but somehow this called the Router twice.
    // @TODO read-later: http://lostechies.com/derickbailey/2011/08/28/dont-execute-a-backbone-js-route-handler-from-your-code/
    // @TODO Uncomment this and make it work (username change in backbone)
    // Router.navigate(this.model.get('username') + '/channels/' + this.model.id);
    // Router.getChannelFacts(Router.getUsername(), this.model.id);

    this.model.set({new_facts: false});
    
    e.preventDefault();
    
    location.href = '/' + this.model.get('username') + '/channels/' + this.model.id;
    
    return false;
  }
});
