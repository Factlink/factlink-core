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


BuildInfo = Struct.new(:uri, :branch)


remote_branches = `git branch -r`.scan /origin\/feature\/.+(?=$)/

puts "Found branches: " + remote_branches.join('; ')
puts "Getting dead feature builds..."

builds = get_jenkins_xml('https://ci-factlink.inverselink.com/view/5%20-%20Features/api/xml')
  .find('/listView/job/url/text()')
  .to_a
  .map { |s| s.to_s.strip }
  .map do |build_uri|
    config_uri = build_uri + "config.xml"
    build_config_xml = get_jenkins_xml(config_uri)
    branch = extract_build_branch( build_config_xml)
    BuildInfo.new(build_uri, branch)
  end

dead_builds = builds.select { |build| ! remote_branches.include?(build.branch) }

missing_branches = remote_branches.select do |branch|
    !builds.any? do |build|
      branch == build.branch
    end
  end

dead_builds.each do |build|
  puts "Delete build of #{build.branch} (#{build.uri})? (y/n)"
  answer = gets
  next unless %(yes y).include? answer.strip
  puts "Deleting..."
  post_jenkins_uri(build.uri + "doDelete")
end
