(function(){
window.FactView = Backbone.View.extend({
  tagName: "div",

  className: "fact-block",

  _currentVisibleDropdown: undefined,

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
    if (typeof this._currentVisibleDropdown === "undefined") {
      console.info( "Showing dropdownContainer" );
      $('.dropdown-container', this.el).slideDown('fast');
    }

    $(this.el).addClass("active");
  },

  hideDropdownContainer: function(className) {
    $(this.el).removeClass("active");
    console.info( "Hiding dropdownContainer" );

    $('.dropdown-container', this.el).slideUp('fast');
  },

  switchToRelationDropdown: function(type){
    if (type === "supporting") {
      this.weakeningFactRelationsView.hide();
      this.supportingFactRelationsView.showAndFetch();
    } else {
      this.supportingFactRelationsView.hide();
      this.weakeningFactRelationsView.showAndFetch();
    }
  },

  toggleEvidence: function(e) {
    var $target = $(e.target).closest('li');
    var $tabButtons = $(this.el).find('.controls li');
    var type = $target.hasClass('supporting') ? 'supporting' : 'weakening';

    $tabButtons.removeClass("active");

    if ( type !== this._currentVisibleDropdown ) {
      this.showDropdownContainer(type);

      this._currentVisibleDropdown = type;

      this.switchToRelationDropdown(type);
      $target.addClass("active");
    } else {
      this.hideDropdownContainer();

      this._currentVisibleDropdown = undefined;
    }

  }
});
})();
