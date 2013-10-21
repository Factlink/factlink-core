require 'net/http'
require 'libxml'

def nodes_to_s(nodes)
  nodes.to_a.map {|node| node.to_s } .join '\n'
end

def jenkins_uri_request(uri_string, requestClass)
  while true
    uri = URI.parse(uri_string)
    request = requestClass.new uri
    request.basic_auth "jenkins", "b0rst1g3b4z3n"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request request
    end
    if %w(301 302).include? response.code
      uri_string = response['location']
    else
      break
    end
  end
  response.body
end


def get_jenkins_uri(uri_string)
  jenkins_uri_request(uri_string, Net::HTTP::Get)
end

def post_jenkins_uri(uri_string)
  jenkins_uri_request(uri_string, Net::HTTP::Post)
end

def parse_xml(string)
  LibXML::XML::Parser.string(string).parse
end

def get_jenkins_xml(uri_string)
  parse_xml(get_jenkins_uri(uri_string))
end

def extract_build_branch(config_xml_doc)
  single(config_xml_doc.find '/project/scm/branches//name/text()').to_s
end

def extract_remote_origin(config_xml_doc)
  single(config_xml_doc.find '/project/scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/url/text()').to_s
end

BuildInfo = Struct.new(:uri, :branch, :origin)

def get_build_info(build_uri)
  config_uri = build_uri + "config.xml"
  build_config_xml = get_jenkins_xml(config_uri)
  branch = extract_build_branch(build_config_xml)
  build_origin = extract_remote_origin(build_config_xml)
  BuildInfo.new(build_uri, branch, build_origin)
end

def single(list)
  has_first = false
  first_item = nil
  list.each do |item|
    raise "single calls with multiple items" unless !has_first
    has_first=true
    first_item=item
  end
  raise "single called with empty enumerable." unless has_first
  first_item
end

`git fetch`
origin_url = `git config --get remote.origin.url`.strip

remote_branches = `git branch -r`.scan /origin\/feature\/.+(?=$)/

puts "Git remote #{origin_url} has the following branches:
" + remote_branches.join("\n")

all_builds = get_jenkins_xml('https://ci-factlink.inverselink.com/view/5%20-%20Features/api/xml')
  .find('/listView/job/url/text()')
  .to_a
  .map { |x| get_build_info(x.to_s.strip) }

builds = all_builds.select { |x| x.origin.strip == origin_url }
dead_builds = builds.select { |build| ! remote_branches.include?(build.branch) }

puts """Found #{all_builds.size} builds
  - of which #{builds.size} for #{origin_url}
  - of which """ +
    if dead_builds.size == 0 then
      "none refer to dead branches."
    else
      "#{dead_builds.size} refer to the following dead branches:\n\n" +
      dead_builds.map { |b| b.branch }.join("\n")
    end

missing_branches = remote_branches.select do |branch|
    !builds.any? do |build|
      branch == build.branch
    end
  end

if dead_builds.size > 0
  puts "Delete the above #{dead_builds.size} jenkins jobs?"
  answer = gets
  if %w(yes y).include? answer.strip
    dead_builds.each do |build|
      puts "Deleting build of #{build.branch} (#{build.uri})..."
      post_jenkins_uri(build.uri + "doDelete")
    end
  end
end
