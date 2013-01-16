/*
   Add a default clickhandler so we can use hrefs
 */
Backbone.View.prototype.defaultClickHandler = function( e ) {
  // Return if a modifier key is pressed or when Backbone has not properly been initialized
  // Make sure we return "true" so other functions can determine what happened
  // Note that the capitalization in Backbone.[H]istory is intentional
  if ( e.metaKey || e.ctrlKey || e.altKey || !Backbone.History.started ) return true;

  var routeTo = $(e.target).closest('a').attr('href');

  Backbone.View.prototype.navigateTo( routeTo );

  e.preventDefault();
  return false;
};

Backbone.View.prototype.navigateTo = function( routeTo ) {
  console.info("Navigating to "+ routeTo, 'from /'+ Backbone.history.fragment);

  if ('/' + Backbone.history.fragment == routeTo) {
    Backbone.history.fragment = null;
    Backbone.history.navigate(routeTo, {trigger: true, replace: true});
  } else {

    var oldFragment = Backbone.history.fragment;

    Backbone.history.navigate(routeTo, false)

    if ( Backbone.history.loadUrl(routeTo) ){
      // backbone supported routing to this page, nothing to be done
    } else {
      Backbone.history.navigate(oldFragment, false)
      window.open(routeTo, '_blank');
      window.focus();
    }
  }

};

/* HACK: this is needed because internal events did not seem to work*/
$(":not(div.factlink-modal) a[rel=backbone]").live("click",Backbone.View.prototype.defaultClickHandler);
