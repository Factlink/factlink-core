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
    "click #create_fact_for_channel .create_factlink .close": "closeCreateFactForm",
    "click #create_fact_for_channel": "focusCreateFactlink",
    "click #create_fact_for_channel .inset-icon.icon-pen": "toggleTitleField",
    "click #create_fact_for_channel .input-box": "focusField"
  },

  tmpl: Template.use("channels", "_facts"),

  initialize: function(options) {
    var self = this;

    this.collection.bind('add', this.add, this);
    this.collection.bind('reset', this.reset, this);
    this.collection.bind('remove', this.removeOne, this);

    //TODO split this into two views, one for channels, one for searchresults
    this.$el.html(this.tmpl.render(options.channel && options.channel.toJSON()));

    this.$el.find('.icon-pen').tooltip({ title: 'Add a title to this Factlink'});

    this.bindScroll();
  },

  createFact: function (e) {
    var self = this;
    var $form = this.$el.find('form');

    var $textarea = $form.find('textarea[name=fact]');
    var $title = $form.find('input[name=title]');
    var $submit = $form.find('button');

    e.preventDefault();

    $form.find(':input').prop('disabled', true);

    $.ajax({
      url: this.collection.url(),
      type: "POST",
      data: {
        displaystring: $textarea.val(),
        title: $title.val()
      },
      success: function(data) {
        var fact = new Fact(data);

        var a = self.collection.unshift(fact);

        self.views[fact.cid].highlight();

        $form.find(':input').val('').prop('disabled',false);

        self.closeCreateFactForm();
      }
    });
  },

  focusField: function (e) {
    $(e.target).closest('input-box').find(':input').focus();
  },

  openCreateFactForm: function () {  this.$el.find('form').addClass('active'); },

  closeCreateFactForm: function (e) {
    this.$el.find('form')
      .removeClass('active show-title')
      .filter(':input').val('');

    e && e.stopPropagation();
  },

  toggleTitleField: function (e) {
    var $form = this.$el.find('form');

    $form.toggleClass('show-title');

    $form.hasClass('show-title') && $form.addClass('active').find('.add-title>input').focus();

    e.stopPropagation();
  },

  focusCreateFactlink: function (e) {
    var $target = $(e.target);

    ! $target.is(':input') && $(e.target).closest('form').find('textarea').focus();
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

  afterAdd: function () {
    this.hideNoFacts();
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
