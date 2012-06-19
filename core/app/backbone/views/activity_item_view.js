(function(){

var GenericActivityItemView = Backbone.Marionette.ItemView.extend({
  tagName:  "div",
  template: "activities/_generic_activity"
});


var CreatedChannelView = GenericActivityItemView.extend({
  template: "activities/_created_channel"
});
var AddedSubchannelView = GenericActivityItemView.extend({
  template: "activities/_added_subchannel"
});


var GenericActivityFactItemView = Backbone.Marionette.CompositeView.extend({
  itemView: FactView,

  initialize: function(opts){
    var fact = new Fact(this.model.get('activity')['fact']);
    this.collection = new Backbone.Collection([fact]);
  }

});

var AddedEvidenceView = GenericActivityFactItemView.extend({
  template: "activities/_added_evidence"
});

var AddedOpinionView = GenericActivityFactItemView.extend({
  template: "activities/_added_opinion"
});
var AddedFactToChannelView = GenericActivityFactItemView.extend({
  template: "activities/_added_fact_to_channel"
});

window.ActivityItemView = function(opts) {
  switch (opts.model.get("action")) {
    case "added_supporting_evidence":
    case "added_weakening_evidence":
      return new AddedEvidenceView(opts);

    case "created_channel":
      return new CreatedChannelView(opts);

    case "added_subchannel":
      return new AddedSubchannelView(opts);

    case "believes":
    case "doubts":
    case "disbelieves":
      return new AddedOpinionView(opts);

    case "added_fact_to_channel":
      return new AddedFactToChannelView(opts);

    default:
      return new GenericActivityItemView(opts);
  }
};

}());
