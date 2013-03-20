# TODO: Investigate when upgrading to Rails 4 || 3.2.14
module Sprockets
  module Helpers
    module RailsHelper
      class AssetPaths < ::ActionView::AssetPaths
        private
        def rewrite_extension(source, dir, ext)
          source_ext = File.extname(source)[1..-1]
          if !ext || ext == source_ext
            source
          elsif source_ext.blank?
            "#{source}.#{ext}"
          elsif File.exists?(source) || exact_match_present?(source)
            source
          else
            "#{source}.#{ext}"
          end
        end
      end
    end
  end
end
