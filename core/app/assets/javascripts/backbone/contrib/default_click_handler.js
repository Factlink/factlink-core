/*
   Add a default clickhandler so we can use hrefs
 */
Backbone.View.prototype.defaultClickHandler = function( e ) {
  console.log("Navigating to "+e.target.getAttribute('href'));

  Router.navigate(e.target.getAttribute('href'), true);
  e.preventDefault();

  return false;
};

/* HACK: this is needed because internal events did not seem to work*/
$("a[rel=backbone]").live("click",Backbone.View.prototype.defaultClickHandler);