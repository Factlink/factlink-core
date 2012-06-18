window.AutoloadingCompositeView = Backbone.Marionette.CompositeView.extend({
  constructor: function(options){
    Backbone.Marionette.CompositeView.prototype.constructor.apply(this, arguments);
    this.actualLoadMore();
  },

  setLoading: function() {
    this.collection._loading = true;
    this.$el.find('div.loading').show();
  },

  stopLoading: function() {
    this.collection._loading = false;
    this.$el.find('div.loading').hide();
  },


  loadMore: function() {
    var self = this;
    var lastModel = self.collection.models[(self.collection.length - 1) || 0];
    var new_timestamp = (lastModel ? lastModel.get('timestamp') : 0);


    if ( self.bottomOfViewReached() && ! self.collection._loading && self._timestamp !== new_timestamp ) {
      self._timestamp = new_timestamp;

      this.actualLoadMore();
    }
  },

  actualLoadMore: function() {
    self = this;
    this.setLoading();
    this.collection.loadMore({
      timestamp: this._timestamp,
      success: function() {
        self.stopLoading();
        self.loadMore();
      },
      error: function() {
        self.stopLoading();
        self.hasMore = false;
      }
    })
  },

  _timestamp: undefined,
  _previousLength: -1,
  hasMore: true,

  bottomOfViewReached: function() {
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

  bindScroll: function() {
    var self = this;
    $(window).bind('scroll.' + this.cid, function MCBiggah() {
      self.loadMore.apply(self);
    });
  },

  unbindScroll: function() {
    $(window).unbind('scroll.' + this.cid);
  },

  close: function() {
    Backbone.Marionette.CompositeView.prototype.close.apply(this, arguments);
    this.unbindScroll();
  },
  

  onRender: function() {
    this.bindScroll();

    if (this.collection.length === 0 && !this.collection._loading) {
      this.showEmpty();
    }

    this.loadMore();
  },


  beforeReset: function(e){
    this.stopLoading();
  },
  
  afterAdd: function () {
    this.hideEmpty();
  },
  
  showEmpty: function(){},
  hideEmpty: function(){}

});

window.FactsView = AutoloadingCompositeView.extend({
  tagName: "div",
  className: "facts",
  containerSelector: ".facts",
  itemView: FactView,
  views: {},
  events: {
    "submit #create_fact_for_channel": "createFact",
    "focus #create_fact_for_channel textarea": "openCreateFactForm",
    "click #create_fact_for_channel .create_factlink .close": "closeCreateFactForm",
    "click #create_fact_for_channel": "focusCreateFactlink",
    "click #create_fact_for_channel .inset-icon.icon-pen": "toggleTitleField",
    "click #create_fact_for_channel .input-box": "focusField"
  },

  template: "channels/_facts",

  initialize: function(options) {
    this.model = options.channel;
  },

  appendHtml: function(collectionView, itemView){
    //TODO: also allow for adding in the middle
    if (collectionView.collection.indexOf(itemView.model) === 0) {
      this.$el.find(this.containerSelector).prepend(itemView.el);
    } else {
      this.$el.find(this.containerSelector).append(itemView.el);
    }
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

        // HACK this is how backbone marionette stores childviews:
        // dependent on their implementation though
        self.children[fact.cid].highlight();

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

  showEmpty: function() {
    this.$el.find('div.no_facts').show();
  },

  hideEmpty: function() {
    this.$el.find('div.no_facts').hide();
  }
});
