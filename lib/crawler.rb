class TorCrawler

  attr_reader :response, :html, :uri, :links

  def initialize(uri)
    @uri = URI.parse(uri)
    @links = []
  end

  def get_response
    binding.pry
    Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) do |http|
      @response = http.get(uri)
    end
  end

  def read
    @html ||= Nokogiri::HTML(@response)
  end

  def get_links
    html.css('a').each do |link|
      links << Link.new(link.attr('href'), link.content, uri.to_s)
    end
  end

  def crawl
    get_response
    read
    get_links
  end

end
