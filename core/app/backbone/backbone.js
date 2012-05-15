//= require jquery
//= require underscore
//= require mustache
//= require backbone.lib
//= require backbone.marionette

//= require twipsy

//= require_tree ./contrib

// Include Fact Model so it can be used inside extended_fact
//= require ./models/fact.js

//= require_tree ./models/

/* We need to load dependencies first. window.FactRelation is being extended
   by Supporting/WeakeningFactRelations */
//= require ./collections/fact_relations.js

//= require_tree ./collections/

// Include FactView so it can be used in ExtendedFactView
//= require ./views/fact_view.js

// Required by Channelcollectionview
//= require ./views/channel_item_view.js

//= require_tree ./views/
//= require ./router.js