//= require jquery
//= require underscore
//= require mustache
//= require backbone.lib
//= require_tree ./backbone/contrib/
//= require_tree ./backbone/models/

/* We need to load dependencies first. window.FactRelation is being extended
   by Supporting/WeakeningFactRelations */
//= require ./backbone/collections/fact_relations.js

//= require_tree ./backbone/collections/
//= require_tree ./backbone/views/
//= require_tree ./backbone/