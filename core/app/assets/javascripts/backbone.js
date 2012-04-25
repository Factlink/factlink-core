//= require jquery
//= require underscore
//= require mustache
//= require backbone.lib

//= require twipsy

//= require_tree ./backbone/contrib/

// Include Fact Model so it can be used inside extended_fact
//= require ./backbone/models/fact.js

//= require_tree ./backbone/models/

/* We need to load dependencies first. window.FactRelation is being extended
   by Supporting/WeakeningFactRelations */
//= require ./backbone/collections/fact_relations.js

//= require_tree ./backbone/collections/

// Include FactView so it can be used in ExtendedFactView
//= require ./backbone/views/fact_view.js

//= require_tree ./backbone/views/
//= require_tree ./backbone/