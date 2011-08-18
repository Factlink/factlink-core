// $Id$

/**
 * @see http://wiki.apache.org/solr/SolJSON#JSON_specific_parameters
 * @class Manager
 * @augments AjaxSolr.AbstractManager
 */
AjaxSolr.Manager = AjaxSolr.AbstractManager.extend(
  /** @lends AjaxSolr.Manager.prototype */
  {
  executeRequest: function (servlet) {
    var self = this;
    if (this.proxyUrl) {
      jQuery.post(this.proxyUrl, { query: this.store.string() }, function (data) { self.handleResponse(data); }, 'json');
    }
    else {
      jQuery.getJSON(this.solrUrl + servlet + '?' + this.store.string() + '&wt=json&json.wrf=?', {}, function (data) { self.handleResponse(data); });
    }
  }
});
