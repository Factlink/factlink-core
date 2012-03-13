# coding: utf-8

require 'unidecode'

module Slugify
  def slugify string
    string.
      gsub(/[-‐‒–—―⁃−­]/, '-').to_ascii.
      downcase.gsub(/[^a-z0-9 ]/, ' ').strip.gsub(/[ ]+/, '-')
  end
end