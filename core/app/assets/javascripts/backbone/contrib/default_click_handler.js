/*
   Add a default clickhandler so we can use hrefs
 */
Backbone.View.prototype.defaultClickHandler = function( e ) {
  if ( e.metaKey || e.ctrlKey || e.altKey ) return;

  var routeTo = $(e.target).closest('a').attr('href');
  console.log("Navigating to "+ routeTo);

  Router.navigate(routeTo, true);
  e.preventDefault();

  return false;
};

/* HACK: this is needed because internal events did not seem to work*/
$("a[rel=backbone]").live("click",Backbone.View.prototype.defaultClickHandler);