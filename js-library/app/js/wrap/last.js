  if (window.jQuery) window.jQuery(window).trigger('factlink.libraryLoaded');

  if (FactlinkConfig.autoStartHighlighting) FACTLINK.startHighlighting();
  if (FactlinkConfig.autoStartAnnotating) FACTLINK.startAnnotating();
})(window.parent, window.parent.document);
