# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'terminal-notifier-guard'

guard :rspec, {
  spec_paths: ["spec"],
  bundler: false,
  all_after_pass: false,
  all_on_start: false,
  cli: ["--color"]
} do
  watch(%r{^spec/(.+)\.rb$})
  watch(%r{^app/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.rb$})       { |m| "spec-unit/#{m[1]}_spec.rb" }
end
