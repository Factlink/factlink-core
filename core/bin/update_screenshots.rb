#!/usr/bin/env ruby
require 'net/http'
require 'json'


class ScreenshotUpdater
  #Uses https://circleci.com/docs/api
  CIRCLE_BASE_URI = "https://circleci.com/api/v1/project/Factlink/core/"

  def local_repo_path
    @local_repo_path ||= begin
      File.dirname(__FILE__) + '/..'
    end
  end

  def local_screenshot_path
    local_repo_path + '/spec/screenshots/screenshots/'
  end

  def circle_token
    @circle_token ||= begin
      ENV['CIRCLE_CI_TOKEN'] or
        fail '''
          ENV variable CIRCLE_CI_TOKEN is missing.
          You should create an api token @ https://circleci.com/account/api and
          insert it in your .bashrc (or equivalent).  For example:
          export CIRCLE_CI_TOKEN="<your-40-char-hexadecimal-token>"
        '''
    end
  end

  def circle_token_query
    "?circle-token=#{circle_token}"
  end

  #https://circleci.com/docs/api#build-artifacts
  #URI.parse('https://circleci.com/api/v1/project/:username/:project/:build_num/artifacts?circle-token=:token

end

