/*
    View.useTemplate() method which loads the mustache templates

    call this in the initialize()
*/
(function() {
  Backbone.View.prototype.useTemplate = function(dir,file) {
    if (this.tmpl !== undefined) { return; }

    this.tmpl = Template.use(dir, file);
  };

  window.Template = {
    use: function (dir, file) {
      return HoganTemplates[dir + "/" + file];
    }
  };
}());
