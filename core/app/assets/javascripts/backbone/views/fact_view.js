(function(){
var currentVisibleDropdown;

window.FactView = Backbone.View.extend({
  tagName: "div",

  className: "fact-block",

  events: {
    "click a.remove": "removeFactFromChannel",
    "click li.destroy": "destroyFact",
	  "click .controls li.supporting,.controls li.weakening": "toggleEvidence"
  },
  initialize: function(opts) {
    this.useTemplate('facts','_fact');
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
    this.initializeFactRelationsViews();

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
  },

  initializeFactRelationsViews: function() {
    var supportingFactRelations = new SupportingFactRelations([], { fact: this.model });
    var weakeningFactRelations = new WeakeningFactRelations([], { fact: this.model });

    this.supportingFactRelationsView = new FactRelationsView({collection: supportingFactRelations});
    this.weakeningFactRelationsView = new FactRelationsView({collection: weakeningFactRelations});

    $('.dropdown-container', this.el).append(this.supportingFactRelationsView.render().el);
    $('.dropdown-container', this.el).append(this.weakeningFactRelationsView.render().el);
  },

  showDropdownContainer: function(className) {
    if (typeof currentVisibleDropdown === "undefined") {
      console.info( "Showing dropdownContainer" );

      $('.dropdown-container', this.el).show();
    }

    currentVisibleDropdown = className;
  },

  hideDropdownContainer: function(className) {
    console.info( "Hiding dropdownContainer" );
    currentVisibleDropdown = undefined;

    $('.dropdown-container', this.el).hide();
  },

  showSupportingDropdown: function() {
    console.info( "Showing Supporting Fact Relations" );
    this.weakeningFactRelationsView.hide();
    this.supportingFactRelationsView.showAndFetch();
  },

  showWeakeningDropdown: function() {
    console.info( "Showing Weakening Fact Relations" );
    this.supportingFactRelationsView.hide();
    this.weakeningFactRelationsView.showAndFetch();
  },

  toggleEvidence: function(e) {
    var $target = $(e.target).closest('li');
    var className = $target.attr('class');

    if (className === "supporting") {
      if ( className !== currentVisibleDropdown ) {
        this.showDropdownContainer(className);

        this.showSupportingDropdown();
      } else {
        this.hideDropdownContainer();
      }
    } else {
      if ( className !== currentVisibleDropdown ) {
        this.showDropdownContainer(className);

        this.showWeakeningDropdown();
      } else {
        this.hideDropdownContainer();
      }
    }
  }
});
})();
