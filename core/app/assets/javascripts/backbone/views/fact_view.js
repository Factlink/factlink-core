window.FactView = Backbone.View.extend({
  tagName: "div",
  
  className: "fact-block",
  
  events: {
    "click a.remove": "removeFactFromChannel",
    "click li.destroy": "destroyFact"
  },
  
  initialize: function(opts) {
    this.useTemplate('facts','_fact')
    this.model.bind('destroy', this.remove, this);
    
    if ( opts.tmpl ) {
      this.tmpl = opts.tmpl;
    }
    
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
    
    // Hides the popup (if necessary)
    if ( parent.remote ) {
      parent.remote.hide();
      parent.remote.stopHighlightingFactlink(this.model.id);
    }
  },
  
  removeFactFromChannel: function() {
    this.model.destroy({ 
      error: function() {
        alert("Error while removing Factlink from Channel" );
      },
      forChannel: true
    });
  },
  
  destroyFact: function() {
    this.model.destroy({ 
      error: function() {
        alert("Error while destroying the Factlink" );
      },
      forChannel: false
    });
  },

  initAddToChannel: function() {
    if ( $(this.el).find('.channel-listing') && typeof currentUser !== "undefined" ) {
      
      var addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        
        el: $(this.el).find('.channel-listing'),
        
        model: this.model,
        
        forFact: this.model
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