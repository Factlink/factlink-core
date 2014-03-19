// Copy-pasted from https://github.com/markijbema/react.backbone/tree/make-mixin-parameterized
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['backbone', 'react'], factory);
    } else {
        // Browser globals
        root.amdWeb = factory(root.Backbone, root.React);
    }
}(this, function (Backbone, React) {
    var _safeForceUpdate = function(){
        if (! this.isMounted()) {
            return;
        }
        (this.onModelChange || this.forceUpdate).call(this);
    };

    getChangeOptions = function(model) {
        if (model instanceof Backbone.Collection) {
            return 'add remove reset sort';
        } else {
            return 'change';
        }
    };

    subscribe = function(model, changeOptions) {
        if (!model) {
            return;
        }

        var _throttledForceUpdate = _.debounce(_safeForceUpdate.bind(this, null),  10);

        model.on(changeOptions, _throttledForceUpdate, this);
    };
    unsubscribe = function(model) {
        if (!model) {
            return;
        }
        model.off(null, null, this);
    };
    React.BackboneMixin = function(prop_name, customChangeOptions){ return {
        componentDidMount: function() {
            // Whenever there may be a change in the Backbone data, trigger a reconcile.
            var changeOptions = customChangeOptions || getChangeOptions.call(this, this.props[prop_name]);
            subscribe.call(this, this.props[prop_name], changeOptions);
        },
        componentWillReceiveProps: function(nextProps) {
            if (this.props[prop_name] === nextProps[prop_name]) {
                return;
            }

            unsubscribe.call(this, this.props[prop_name]);
            subscribe.call(this, nextProps[prop_name]);

            if (typeof this.componentWillChangeModel === 'function') {
                this.componentWillChangeModel();
            }
        },
        componentDidUpdate: function(prevProps, prevState) {
            if (this.props[prop_name] === prevProps[prop_name]) {
                return;
            }

            if (typeof this.componentDidChangeModel === 'function') {
                this.componentDidChangeModel();
            }
        },
        componentWillUnmount: function() {
            // Ensure that we clean up any dangling references when the component is destroyed.
            unsubscribe.call(this, this.props[prop_name]);
        }
    };};

    React.BackboneViewMixin = {
        getModel: function() {
            return this.props.model;
        },
        model: function() {
            return this.getModel();
        },
        el: function() {
            return this.isMounted() && this.getDOMNode();
        }
    };

    React.createBackboneClass = function(spec) {
        var currentMixins = spec.mixins || [];

        spec.mixins = currentMixins.concat([
            React.BackboneMixin('model', this.changeOptions),
            React.BackboneViewMixin
        ]);
        return React.createClass(spec);
    };

    return React;

}));
