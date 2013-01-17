window.AutoloadCollectionOnTimestamp = {
  _loading: undefined,
  _timestamp: undefined,
  hasMore: true,

  updateTimestamp: function(){
    var lastModel = this.models[(this.length - 1) || 0];
    this._timestamp = (lastModel ? lastModel.get('timestamp') : undefined);
  },

  startLoading: function(){
    this._loading = true;
    this.trigger('startLoading',this);
  },

  stopLoading: function(){
    this._loading = false;
    this.trigger('stopLoading',this);
  },

  needsMore: function(){
    return this.hasMore && ! this._loading;
  },

  loadMore: function() {
    var prevlength;
    if( ! this.needsMore() ) {return;}

    prevlength = this.length;

    this.startLoading();
    this.fetch({
      add: true,
      data: {
        timestamp: this._timestamp
      },
      success: _.bind(function() {
        this.updateTimestamp();
        if (prevlength === this.length){
          this.hasMore = false;
        }
        this.stopLoading();
      }, this),
      error: _.bind(function() {
        this.updateTimestamp();
        this.hasMore = false;
        this.stopLoading();
      }, this)
    });
  }
}
