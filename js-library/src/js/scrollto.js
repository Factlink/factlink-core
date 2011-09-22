(function(Factlink) {
  Factlink.scrollTo = function(fact_id){
    $('body')._scrollable().scrollTo("span[data-factid="+fact_id+"]");
  };
})(window.Factlink);
