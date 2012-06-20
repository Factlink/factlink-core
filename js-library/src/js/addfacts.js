// this is a script called from the extension
(function(Factlink, window) {
    var el = window.document.getElementById("factlink-opinion-holder");
    var opinion;

    if (el !== undefined) {
      opinion = el.getAttribute("data-opinion");

      el.parentNode.removeChild(el);
    }

    Factlink.createFactFromSelection(opinion);
})(window.Factlink, Factlink.global);
