#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'cgi'

class ScreenshotUpdater
  #Uses https://circleci.com/docs/api
  CIRCLE_BASE_URI = 'https://circleci.com/api/v1/project/Factlink/factlink/'

  def run
    get_lastest_screenshot_uris.each do |screenshot_uri|
      filename = local_screenshot_path + local_filename_from_uri(screenshot_uri)

      system "curl -o #{filename} #{screenshot_uri}"
    end
  end

  def local_filename_from_uri uri
    File.basename(URI.parse(uri).path)
  end

  def local_screenshot_path
    local_repo_path + '/spec/screenshots/screenshots/'
  end

  def local_repo_path
    @local_repo_path ||= begin
      File.dirname(__FILE__) + '/..'
    end
  end

  def get_lastest_screenshot_uris
    build_num = get_latest_build_num
    screenshot_infos =
        get_json(ci_artifacts_uri(build_num))
        .select{|artifact| artifact['pretty_path'].match(/^\$CIRCLE_ARTIFACTS\/capybara_output\//)}

    screenshot_infos
        .map{|artifact| artifact['url']}
        .select{|url| url.end_with?('.png') && !url.end_with?('-diff.png')}
        .map{|url| url + circle_token_query}
  end

  def get_latest_build_num
    recent_builds = get_recent_builds
    raise "No branch #{current_git_branch} found." unless recent_builds && recent_builds[0]
    build_info = recent_builds[0]
    raise "No recent build for branch #{current_git_branch}." unless build_info
    build_info['build_num']
  end

  def get_recent_builds
    get_json(ci_current_branch_builds_uri)
  end

  def ci_artifacts_uri(build_num)
    URI.parse("#{CIRCLE_BASE_URI}#{build_num}/artifacts#{circle_token_query}")
  end

  def ci_current_branch_builds_uri
    URI.parse("#{CIRCLE_BASE_URI}tree/#{CGI.escape(current_git_branch)}#{circle_token_query}")
  end

  def circle_token_query
    "?circle-token=#{circle_token}"
  end

  def circle_token
    @circle_token ||= begin
      ENV['CIRCLE_CI_TOKEN'] or
        fail '''
          ENV variable CIRCLE_CI_TOKEN is missing.
          You should create an api token @ https://circleci.com/account/api and
          insert it in your `.bash_profile` for OS X, `.zshrc` for zsh, and `.bashrc` for non-mac bash.
          For example:
          export CIRCLE_CI_TOKEN="<your-40-char-hexadecimal-token>"
        '''
    end
  end

  def current_git_branch
    `git symbolic-ref HEAD`.sub(/^refs\/heads\//,'').strip
  end

  # HTTP helpers:
  def get_json(uri)
    JSON.parse(make_http_request(uri, Net::HTTP::Get))
  end

  def make_http_request(uri, requestClass)
    while true
      request = requestClass.new uri
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request request
      end
      if %w(301 302).include? response.code
        uri = URI.parse(response['location'])
      elsif response.code == '200'
        break
      else
        raise "Failed to request #{uri}; response code #{response.code}"
      end
    end
    response.body
  end
end


ScreenshotUpdater.new.run
