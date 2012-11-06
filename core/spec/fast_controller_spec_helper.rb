if Object.const_defined?(:Rails)
  require_relative 'spec_helper.rb'
else
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
  $: << File.join(APP_ROOT, "app", "controllers")

  module ActionController
    class Base
      def self.protect_from_forgery; end
      def params; {}; end
    end
  end

  class ApplicationController
  end

  def stub_params(options = {})
    controller.class.send(:define_method, :params) do
      options
    end
  end

  def assigns(name)
    controller.instance_variable_get "@#{name}"
  end
end
