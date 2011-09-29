window.ChannelMenuView = Backbone.View.extend({
  tagName: "li",
  template: _.template($('#channel_li').html()),
  
  events: {
    "click" : "showFacts"
  },
  
  initialize: function() {
    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
  },
  
  render: function() {
    $( this.el )
      .html( this.template( {channel: this.model.toJSON() } ) )
      .attr('id', 'channel-' + this.model.id);
    return this;
  },
  
  setActive: function() {
    $( this.el ).addClass('active');
  },
  
  setNotActive: function() {
    $( this.el ).removeClass('active');
  },
  
  remove: function() {
    $( this.el ).remove();
  },
  
  showFacts: function() {
    window.location.hash = 'tomdev/channels/' + this.model.id + '/facts';
  }
});