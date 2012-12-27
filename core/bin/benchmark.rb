#!/usr/bin/env ruby

require 'benchmark'

REGEXPS = [
  /^no such file to load -- (.+)$/i,
  /^Missing \w+ (?:file\s*)?([^\s]+.rb)$/i,
  /^Missing API definition file in (.+)$/i,
  /^cannot load such file -- (.+)$/i,
]

def pull(dep)
  required_file = nil

  begin
    # Loop through all the specified autorequires for the
    # dependency. If there are none, use the dependency's name
    # as the autorequire.
    Array(dep.autorequire || dep.name).each do |file|
      required_file = file
      Kernel.require file
    end
  rescue LoadError => e
    if dep.autorequire.nil? && dep.name.include?('-')
      begin
        namespaced_file = dep.name.gsub('-', '/')
        Kernel.require namespaced_file
      rescue LoadError
        REGEXPS.find { |r| r =~ e.message }
        raise if dep.autorequire || $1.gsub('-', '/') != namespaced_file
      end
    else
      REGEXPS.find { |r| r =~ e.message }
      raise if dep.autorequire || $1 != required_file
    end
  end
end

require 'rails/all'

# If you would prefer gems to incur the cost of autoloading
# Rails frameworks, then comment out this next line.
ActiveSupport::Autoload.eager_autoload!

$VERBOSE = nil

Benchmark.bm do |x|
  Bundler.setup.dependencies.each do |dependency|
    x.report(dependency.name[0..20].ljust(21)) do
      pull(dependency)
    end
  end
end