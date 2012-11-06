if Object.const_defined?(:Rails)
  require_relative 'spec_helper.rb'
else
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
  $: << File.join(APP_ROOT, "app", "controllers")

  def stub_params(options = {})
    controller.class.send(:define_method, :params) do
      options
    end
  end

  def assigns(name)
    controller.instance_variable_get "@#{name}"
  end
end
