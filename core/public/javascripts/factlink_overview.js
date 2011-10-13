(function(window) {
  // Check if all Factlinks are loaded
  window.isFullyLoaded = false;

  $(window).infiniScroll({
    isFullyLoaded: function() {
      return window.isFullyLoaded;
    },
    
    url: function(page) {
      var sort_direction;
      var sort_column;
      var loc = location.pathname.split("/");
      var search_string = /\?s=(.*)/.exec(window.location.search);
      
      // Check if the user is currently sorting    
      if (loc[loc.length - 1] === "asc" || loc[loc.length - 1] === "desc") {
        sort_direction = loc[loc.length - 1];
        sort_column = loc[loc.length - 2];
      }
      
      return '/search/page/' + page + (sort_direction && sort_column ? '/' + sort_column + '/' + sort_direction : "") + '.js' + (search_string && search_string.length === 2 ? "?s=" + search_string[1] : "")
    }
  });
})(window);