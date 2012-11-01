/*
   Add a default clickhandler so we can use hrefs
 */
Backbone.View.prototype.defaultClickHandler = function( e ) {
  // Return if a modifier key is pressed or when Backbone has not properly been initialized
  // Make sure we return "true" so other functions can determine what happened
  // Note that the capitalization in Backbone.[H]istory is intentional
  if ( e.metaKey || e.ctrlKey || e.altKey || !Backbone.History.started ) return true;

  var routeTo = $(e.target).closest('a').attr('href');
  console.log("Navigating to "+ routeTo, 'from /'+ Backbone.history.fragment);

  if ('/' + Backbone.history.fragment == routeTo) {
    Backbone.history.fragment = null;
    Backbone.history.navigate(routeTo, {trigger: true, replace: true});
  } else {
    Backbone.history.navigate(routeTo, {trigger: true});
  }

  e.preventDefault();
  return false;
};

/* HACK: this is needed because internal events did not seem to work*/
$(":not(div.modal) a[rel=backbone]").live("click",Backbone.View.prototype.defaultClickHandler);
