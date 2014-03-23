class TorCrawler

  attr_reader :response, :html, :uri, :links

  def initialize(uri)
    @uri = URI.parse(uri)
    if @uri.host == nil || @uri.scheme == nil
      return raise ArgumentError
    end
    @links = []
  end

  def get_response
    Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
      @response = http.get(uri)
    end
  end

  def read
    @html ||= Nokogiri::HTML(@response.body)
  end

  def get_links
    html.css('a').each do |link|
      links << { :link => link, :found_on => uri.to_s }
    end
  end

  def crawl
    get_response
    read
    get_links
  end

  class ArgumentError < StandardError
  end
end
