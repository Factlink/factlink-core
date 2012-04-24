(function(){
window.FactView = Backbone.View.extend({
  tagName: "div",

  className: "fact-block",

  _currentVisibleDropdown: undefined,

  events: {
    "click a.remove": "removeFactFromChannel",
    "click li.destroy": "destroyFact",
    "click .controls .supporting, .controls .weakening": "toggleEvidence",
    "click .title.edit": "toggleTitleEdit",
    "focus .title.edit>input": "focusTitleEdit",
    "blur .title.edit>input": "saveTitleEdit",
    "keydown .title.edit>input": "parseKeyInputTitleEdit"
  },

  initialize: function(opts) {
    this.useTemplate('facts','_fact'); // use after setting this.tmpl

    this.model.bind('destroy', this.remove, this);
    this.model.bind('change', this.render, this);

    this.$el.attr('data-fact-id', ( this.model.id || this.model.cid )).factlink();

    this.initAddToChannel();
    this.initFactRelationsViews();
    this.initUserPassportViews();
  },

  partials: {},

  render: function() {
    this.$el
      .html( Mustache.to_html(this.tmpl, this.model.toJSON(), this.partials)).factlink();

    this.initAddToChannel();
    this.initFactRelationsViews();
    this.initUserPassportViews();

    this.$el.find('.authority').tooltip();

    return this;
  },

  remove: function() {
    this.$el.fadeOut('fast', function() {
      $(this).remove();
    });

    // Hides the popup (if necessary)
    if ( parent.remote ) {
      parent.remote.hide();
      parent.remote.stopHighlightingFactlink(this.model.id);
    }
  },

  removeFactFromChannel: function(e) {
    e.preventDefault();

    if(!confirm("Are you sure you want to remove this Factlink from the current channel?")) return false;

    var self = this;

    this.model.removeFromChannel({
      error: function() {
        alert("Error while removing Factlink from Channel" );
      },
      success: function() {
        try {
          mpmetrics.track("Channel: Silence Factlink from Channel", {
            factlink_id: self.model.id,
            channel_id: currentChannel.id
          });
        } catch(e) {}
      }
    });
  },

  destroyFact: function(e) {
    e.preventDefault();

    if(!confirm("Are you sure you want to delete the Factlink you have created?")) return false;

    this.model.destroy({
      error: function() {
        alert("Error while removing the Factlink" );
      },
      success: function() {
        try {
          mpmetrics.track("Factlink: Destroy", {
            factlink_id: self.model.id
          });
        } catch(e) {}
      }
    });
  },

  initAddToChannel: function() {
    if ( this.$el.find('.channel-listing') && typeof currentUser !== "undefined" ) {

      var addToChannelView = new AddToChannelView({
        collection: currentUser.channels,

        el: this.$el.find('.channel-listing'),

        model: this.model,

        forFact: this.model
      }).render();

      // Channels are in the container
      $('.add-to-channel', this.$el)
        .hoverIntent(function(e) {
          addToChannelView.$el.fadeIn("fast");
        }, function() {
          addToChannelView.$el.delay(600).fadeOut("fast");
        });
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

    $('.dropdown-container', this.el)
      .append( this.supportingFactRelationsView.render().el )
      .append( this.weakeningFactRelationsView.render().el );
  },

  showDropdownContainer: function(className) {
    if (typeof this._currentVisibleDropdown === "undefined") {
      $('.dropdown-container', this.el).slideDown('fast');
    }

    this.$el.addClass("active");
  },

  hideDropdownContainer: function(className) {
    this.$el.removeClass("active");

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
    var self = this;
    var $target = $(e.target).closest('li');
    var $tabButtons = this.$el.find('.controls li');
    var type = $target.hasClass('supporting') ? 'supporting' : 'weakening';

    try {
      mpmetrics.track("Factlink: Open tab", {
        factlink_id: self.model.id,
        type: type
      });
    } catch(e) {}

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
  },

  initUserPassportViews: function() {
    var self = this;
    $(this.model.get("interacting_users")["activity"]).each(function()  {
      var el = $("li.user[data-activity-id="+ this.id + "]", self.el);
      var model = new User(this.user);
      var view = new UserPassportView({model: model, el: el, activity: this});
    });
  },

  highlight: function() {
    var self = this;
    self.$el.animate({"background-color": "#ffffe1"}, {duration: 2000, complete: function() {
      $(this).animate({"background-color": "#ffffff"}, 2000);
    }});
  },

  toggleTitleEdit: function () {
    var $editField = this.$el.find('.edit.title');

    if ( ! this._titleFieldHasFocus ) {
      $editField.toggleClass('edit-active');

      if ( $editField.hasClass('edit-active') ) {
        $editField.find('input').focus();
      }
    }
  },

  focusTitleEdit: function () {
    this._titleFieldHasFocus = true;
  },

  saveTitleEdit: function () {
    if ( this._titleFieldHasFocus ) {
      var self = this;
      var $titleField = this.$el.find('.edit.title');
      var value = $titleField.find('>input').val();

      $titleField.find('>span').html(value);
      $titleField.removeClass('edit-active');

      this._titleFieldHasFocus = false;

      if ( this.model.getTitle() === value ) {
        return;
      }

      // TODO: Please replace this with a proper Backbone.Model.prototype.save
      //       Once we got rid of Mustache
      if ( this.model.setTitle(value, { silent: true } ) ) {
        $.ajax({
          type: "PUT",
          url: this.model.url(),
          data: {
            title: value
          }
        }).done(function() {
          self.model.trigger('change');
        }).error(function() {
          alert("Something went wrong while trying to save this Factlink. Please try again");
        });
      }
    }
  },

  parseKeyInputTitleEdit: function (e) {
    if ( e.keyCode === 13 ) {
      this.saveTitleEdit();

      e.preventDefault();
    }
  }
});
})();
