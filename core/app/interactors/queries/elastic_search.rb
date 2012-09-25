require 'cgi'

class ElasticSearch
  private
  def process_keywords
    @keywords.split(/\s+/).map{|x| "*#{CGI::escape(x)}*"}.join("+")
  end

  def handle_httparty_error results
    case results.code
      when 200..299
      when 400..499
        error = "Client error, status code: #{results.code}, response: '#{results.response}'."
      when 500..599
        error = "Server error, status code: #{results.code}, response: '#{results.response}'."
      else
        error = "Unexpected status code: #{results.code}, response: '#{results.response}'."
    end

    if error
      @logger.error(error)
      raise error
    end
  end
end
