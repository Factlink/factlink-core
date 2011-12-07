window.FactView = Backbone.View.extend({
  tagName: "div",
  
  className: "fact-block",
  
  tmpl: $('#fact_tmpl').html(),
  
  events: {
    "click a.remove": "removeFact",
    "click .add-to-channel": "addToChannelClick"
  },
  
  partials: {
    fact_bubble: $('#fact_bubble_tmpl').html(),
    fact_wheel: $('#fact_wheel_tmpl').html()
  },
  
  initialize: function(e) {
    this.model.bind('destroy', this.remove, this);
    
    $(this.el).attr('data-fact-id', this.model.id);
  },
  
  render: function() {
    $( this.el )
      .html( Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials)).factlink();
    
    this.initAddToChannel();
    
    return this;
  },
  
  remove: function() {
    $(this.el).fadeOut('fast', function() {
      $(this.el).remove();
    });
  },
  
  addToChannelClick: function(e) {
    e.preventDefault();
  },
  
  removeFact: function() {
    this.model.destroy({ error: function() {
      alert("Error while removing Factlink from Channel" );
    }});
  },

  initAddToChannel: function() {
    if ( $(this.el).find('.channel-listing') && typeof currentUser !== "undefined" ) {
      
      var addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        
        el: $(this.el).find('.channel-listing'),
        
        containingChannels: this.model.getOwnContainingChannels()
      }).render();
      
      // Channels are in the container
      $('.add-to-channel', this.el)
        .hoverIntent(function(e) {
          addToChannelView.el.fadeIn("fast");
        }, function() {
          addToChannelView.el.delay(600).fadeOut("fast");
        });
    }
  }
});