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
    this.collection.on('startLoading', this.startLoading, this);
    this.collection.on('stopLoading', this.stopLoading, this);
  },

  startLoading: function() {
    this.$el.find('div.loading').show();
  },

  stopLoading: function() {
    this.$el.find('div.loading').hide();
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
