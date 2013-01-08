// All the default libraries/files needed for all pages on Factlink
//= require jquery
//= require jquery_ujs
//= require underscore
//= require hogan
//= require andlog
//= require trunk8
//= require twitter/bootstrap
//= require jquery.color
//= require jquery.placeholder

//= require globals/globals

//= require_tree ./base
//= require_tree ./lib

// This only affects the inputs/textareas that aren't loaded through Backbone Views
$(function() {
  $('input, textarea').placeholder();
});