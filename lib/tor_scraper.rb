class TorScraper
  UA = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0'

  attr_reader :response, :html, :uri, :links, :page

  def initialize(uri)
    @uri = URI.parse(uri)
   if @uri.host == nil
      return raise ArgumentError
   end
    @links = []
    @page = {}
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

  def page_description
    html.css("meta[name=description]")[0].attribute("content").value
  end

  def page_title
    html.css("title")[0].content
  end

  def get_page
    @page = {
      :site_name => uri.host,
      :href => uri.to_s,
      :title => page_title,
      :description => page_description,
      :links => links
    }
  end

  def scrape
    get_response
    read
    get_links
    get_page
  end

  class ArgumentError < StandardError
    def message
      "URI must include http:// to resolve hidden service urls"
    end
  end
end
