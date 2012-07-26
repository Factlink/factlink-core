(function(){
var ViewWithPopover = extendWithPopover( Backbone.Factlink.PlainView );

window.FactView = ViewWithPopover.extend({
  tagName: "div",

  className: "fact-block",

  events: {
    "click .hide-from-channel": "removeFactFromChannel",
    "click li.delete": "destroyFact",

    "click .tab-control .supporting"     : "tabClick",
    "click .tab-control .weakening"      : "tabClick",
    "click .tab-control .add-to-channel" : "tabClick",

    "click a.more": "showCompleteDisplaystring",
    "click a.less": "hideCompleteDisplaystring"
  },

  template: "facts/_fact",

  partials: {
    fact_bubble: "facts/_fact_bubble",
    fact_wheel: "facts/_fact_wheel",
    interacting_users: "facts/_interacting_users"
  },

  interactingUserViews: [],

  popover: [
    {
      selector: ".top-right-arrow",
      popoverSelector: "ul.top-right"
    }
  ],

  initialize: function(opts) {
    this._currentTab = undefined;
    this.interactingUserViews = [];

    this.model.bind('destroy', this.close, this);
    this.model.bind('change', this.render, this);

    this.initAddToChannel();
    this.initFactRelationsViews();

    this.wheel = new Wheel(this.model.getFactWheel());
  },

  onRender: function() {
    this.renderAddToChannel();
    this.initFactRelationsViews();

    this.$('.authority').tooltip();

    if ( this.factWheelView ) {
      this.wheel.set(this.model.getFactWheel());
      this.$('.wheel').replaceWith(this.factWheelView.reRender().el);
    } else {
      this.factWheelView = new InteractiveWheelView({
        model: this.wheel,
        fact: this.model,
        el: this.$('.wheel')
      }).render();
    }
  },

  remove: function() {
    this.$el.fadeOut('fast', function() {
      $(this).remove();
    });

    _.each(this.interactingUserViews, function(view){
      view.close();
    },this);

    if(this.addToChannelView){
      this.addToChannelView.close();
    }
    // Hides the popup (if necessary)
    if ( parent.remote ) {
      parent.remote.hide();
      parent.remote.stopHighlightingFactlink(this.model.id);
    }
  },

  removeFactFromChannel: function(e) {
    e.preventDefault();

    var self = this;

    this.model.removeFromChannel(
      currentChannel, {
      error: function() {
        alert("Error while hiding Factlink from Channel" );
      },
      success: function() {
        self.model.collection.remove(self.model);
        mp_track("Channel: Silence Factlink from Channel", {
          factlink_id: self.model.id,
          channel_id: currentChannel.id
        });
      }
    });
  },

  destroyFact: function(e) {
    e.preventDefault();

    this.model.destroy({
      error: function() {
        alert("Error while removing the Factlink" );
      },
      success: function() {
        mp_track("Factlink: Destroy");
      }
    });
  },

  initAddToChannel: function() {
  },

  renderAddToChannel: function() {
    var self = this;
    var add_el = '.tab-content .add-to-channel .dropdown-container .wrapper .add-to-channel-container';
    if ( this.$(add_el).length > 0 && typeof currentUser !== "undefined" ) {
      var addToChannelView = new AutoCompletedAddToChannelView({
        el: this.$(add_el)[0]
      });
      _.each(this.model.getOwnContainingChannels(),function(ch){
        //hacky hacky bang bang
        if (ch.get('type') === 'channel'){
          addToChannelView.collection.add(ch);
        }
      });
      addToChannelView.vent.bindTo("addChannel", function(channel){
        self.model.addToChannel(channel,{});
      });
      addToChannelView.vent.bindTo("removeChannel", function(channel){
        self.model.removeFromChannel(channel,{});
        if (window.currentChannel && currentChannel.get('id') === channel.get('id')){
          self.model.collection.remove(self.model);
        }
      });
      addToChannelView.render();
      this.addToChannelView = addToChannelView;
    }
  },

  initFactRelationsViews: function() {
    var supportingFactRelations = new SupportingFactRelations([], { fact: this.model } );
    var weakeningFactRelations = new WeakeningFactRelations([], { fact: this.model } );

    this.supportingFactRelationsView = new FactRelationsView({
      collection: supportingFactRelations,
      type: "supporting"
    });

    this.weakeningFactRelationsView = new FactRelationsView({
      collection: weakeningFactRelations,
      type: "weakening"
    });

   $('.supporting .dropdown-container', this.el)
   .append( this.supportingFactRelationsView.render().el );

   $('.weakening .dropdown-container', this.el)
   .append( this.weakeningFactRelationsView.render().el );
  },

  switchToRelationDropdown: function(type){
    mp_track("Factlink: Open tab", {factlink_id: this.model.id,type: type});

    if (type === "supporting") {
      this.weakeningFactRelationsView.hide();
      this.supportingFactRelationsView.fetchAndShow();
    } else {
      this.supportingFactRelationsView.hide();
      this.weakeningFactRelationsView.fetchAndShow();
    }
  },

  tabClick: function(e) {

    e.preventDefault();
    e.stopPropagation();

    var $target = $(e.target).closest('li');

    // Need a way to identify the clicked tab. Using the li class sucks monkeyballs.
    tab = $target.attr('class').split(' ')[0];

    // Remove .active
    var $tabButtons = this.$el.find('.tab-control li');
    $tabButtons.removeClass("active");

    if (tab !== this._currentTab) {
      // Open the clicked tab
      this._currentTab = tab;
      this.hideTabs();

      $target.addClass('active');
      // Show the tab
      this.$('.tab-content > .' + tab).show();
      // Keep showing the tabs (in the li)
      this.$('.tab-control > li').addClass('tabOpened');
      this.handleTabActions(tab);

    } else {
      // Same tab was clicked - hide it!
      this.hideTabs();
      this._currentTab = undefined;
    }
  },

  hideTabs: function() {
    this.$('.tab-content > div').hide();
    this.$('.tab-control > li').removeClass('tabOpened');
  },

  handleTabActions: function(tab) {
    switch (tab) {
    case "supporting":
    case "weakening":
      this.switchToRelationDropdown(tab);
      return true;

    case "channels":
      return true;

    default:
      return true;
    }
  },

  highlight: function() {
    var self = this;
    self.$el.animate({"background-color": "#ffffe1"}, {duration: 2000, complete: function() {
      $(this).animate({"background-color": "#ffffff"}, 2000);
    }});
  },

  showCompleteDisplaystring: function (e) {
    this.$('.normal').hide().siblings('.full').show();
  },

  hideCompleteDisplaystring: function (e) {
    this.$('.full').hide().siblings('.normal').show();
  }
});
})();
