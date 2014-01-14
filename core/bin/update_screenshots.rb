#!/usr/bin/env ruby
require 'net/http'
require 'json'


class ScreenshotUpdater
  def local_repo_path
    @local_repo_path ||= begin
      File.dirname(__FILE__) + '/..'
    end
  end

  def local_screenshot_path
    local_repo_path + '/spec/screenshots/screenshots/'
  end

  def ci_token
    @ci_token ||= begin
      ENV['CIRCLE_CI_TOKEN'] or
        fail '''
          ENV variable CIRCLE_CI_TOKEN is missing.
          You should create an api token @ https://circleci.com/account/api and
          insert it in your .bashrc (or equivalent).  For example:
          export CIRCLE_CI_TOKEN="<your-40-char-hexadecimal-token>"
        '''
    end
  end

  def ci_projects_uri
    @ci_projects_uri ||= URI.parse("https://circleci.com/api/v1/projects?circle-token=#{ci_token}")
  end

  #https://circleci.com/docs/api#build-artifacts
  #URI.parse('https://circleci.com/api/v1/project/:username/:project/:build_num/artifacts?circle-token=:token

end

