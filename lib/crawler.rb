class TorCrawler
  UA = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0'

  attr_reader :response, :html, :uri, :links

  def initialize(uri)
    @uri = URI.parse(uri)
   if @uri.host == nil
      return raise ArgumentError
   end
    @links = []
  end

  def get_response
    @con = Net::HTTP.SOCKSProxy('127.0.0.1', 9050)
    @con.start(uri.hostname, uri.port, {"User-Agent" => UA}) do |http|
      @response = http.get(uri.request_uri)
    end
  end

  def read
    @html ||= Nokogiri::HTML(@response.body)
  end

  def get_links
    html.css('a').each do |link|
      href = link.attribute("href").value
      if href && href !=~ /[mailto:|javascript:]/
        links << { :href => href, :content => link.content, :found_on => uri.to_s }
      end
    end
  end

  def crawl
    get_response
    read
    get_links
  end

  class ArgumentError < StandardError
    def message
      "URI must include http:// to resolve hidden service urls"
    end
  end
end
