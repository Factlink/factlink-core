(function(Factlink, $, _, easyXDM, undefined) {
  Factlink.scrollTo = function(fact_id){
    $('body')._scrollable().scrollTo("span[data-factid="+fact_id+"]", 500);
  };
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);