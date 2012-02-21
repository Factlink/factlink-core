//= require application
//= require jquery.prevent_scroll_propagation
//= require twitter/bootstrap
//= require bubble
//= require modal
//= require tour
//= require feedback
//= require_tree ./frontend
//= require twipsy

$(".alert-message").alert();

$('.topbar').dropdown();
$('.bookmarklet').twipsy({placement:"below",offset:5});

