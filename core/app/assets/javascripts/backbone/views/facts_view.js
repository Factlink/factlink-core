window.FactsView = Backbone.CollectionView.extend({
  tagName: "div",
  className: "facts",
  containerSelector: ".facts",
  modelView: FactView,
  _loading: true,
  _timestamp: undefined,
  _previousLength: -1,
  views: {},
  events: {
    "submit #create_fact_for_channel": "createFact",
    "focus #create_fact_for_channel textarea": "openCreateFactForm",
    "blur #create_fact_for_channel textarea": "closeCreateFactForm"
  },

  initialize: function(options) {
    this.useTemplate("channels", "_facts");

    var self = this;

    this.collection.bind('add', this.add, this);
    this.collection.bind('reset', this.reset, this);
    this.collection.bind('remove', this.removeOne, this);

    //TODO split this into two views, one for channels, one for searchresults
    if(options.channel !== undefined ) {
      this.$el.html(Mustache.to_html(this.tmpl,options.channel.toJSON(), this.partials));
    } else {
      this.$el.html(Mustache.to_html(this.tmpl, {}, this.partials));
    }
    this.bindScroll();
  },

  createFact: function (e) {
    var self = this;
    var $textarea = this.$el.find('#create_fact_for_channel textarea');
    var $submit = this.$el.find('#create_fact_for_channel button');

    e.preventDefault();

    $textarea.prop('disabled', true);
    $submit.prop('disabled', true);

    $.ajax({
      url: this.collection.url(),
      type: "POST",
      data: {
        displaystring: $textarea.val()
      },
      success: function(data) {
        var fact = new Fact(data);

        var a = self.collection.unshift(fact);

        self.views[fact.cid].highlight();

        $textarea.val('').prop('disabled', false);
        $submit.prop('disabled', false);
      }
    });
  },

  openCreateFactForm: function (e) {
    var $textarea = this.$el.find('#create_fact_for_channel textarea');

    $textarea.stop().animate({
      height: 75
    }, function() {
      $(this).closest('form').addClass('active');
    });
  },

  closeCreateFactForm: function (e) {
    var $textarea = this.$el.find('#create_fact_for_channel textarea');

    $textarea.closest('form').removeClass('active');

    $textarea.stop().animate({
      height: 35
    });
  },

  removeOne: function (fact) {
    this.views[fact.cid].remove();
  },

  render: function() {
    var self = this;

    if (this.collection.length === 0 && !this._loading) {
      this.showNoFacts();
    } else {
      this.collection.forEach(function(fact) {
        self.add(fact);
      });
    }

    if ( this._previousLength === this.collection.length ) {
      this.hasMore = false;
    } else {
      this._previousLength = this.collection.length;
    }

    this.loadMore();

    return this;
  },

  remove: function() {
    Backbone.View.prototype.remove.apply(this);

    this.unbindScroll();
  },

  beforeReset: function(e){
    this.stopLoading();
  },

  moreNeeded: function() {
    var bottomOfTheViewport = window.pageYOffset + window.innerHeight;
    var bottomOfEl = this.$el.offset().top + this.$el.outerHeight();

    if ( this.hasMore ) {
      if ( bottomOfEl < bottomOfTheViewport ) {
        return true;
      } else if ($(document).height() - ($(window).scrollTop() + $(window).height()) < 700) {
        return true;
      }
    }

    return false;
  },

  loadMore: function() {
    var self = this;
    var lastModel = self.collection.models[(self.collection.length - 1) || 0];
    var new_timestamp = (lastModel ? lastModel.get('timestamp') : 0);

     if ( self.moreNeeded() && ! self._loading && self._timestamp !== new_timestamp ) {
      self.setLoading();

      self._timestamp = new_timestamp;

      self.collection.fetch({
        add: true,
        data: {
          timestamp: self._timestamp
        },
        success: function() {
          self.stopLoading();
          self.loadMore();
        },
        error: function() {
          self.stopLoading();
          self.hasMore = false;
        }
      });
    }
  },

  hasMore: true,

  showNoFacts: function() {
    this.$el.find('div.no_facts').show();
  },

  hideNoFacts: function() {
    this.$el.find('div.no_facts').hide();
  },

  setLoading: function() {
    this._loading = true;
    this.$el.find('div.loading').show();
  },

  stopLoading: function() {
    this._loading = false;
    this.$el.find('div.loading').hide();
  },

  bindScroll: function() {
    var self = this;
    $(window).bind('scroll.' + this.cid, function MCBiggah() {
      self.loadMore.apply(self);
    });
  },

  unbindScroll: function() {
    $(window).unbind('scroll.' + this.cid);
  }
});
