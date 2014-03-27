class TorScraper
  UA = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0'
  VERBOTEN = [/\.(jpe?g|gif|png|js|tiff?|\w?zip|pdf|doc|txt|mov|mpe?g|avi|mp\d|asc|tar|gz|xz|exe|dmg|rtf|iso|tmp|c)$/i, /javascript:|mailto:/i, /^\./, /\.?ftp\.?:?/, /^#/]
  attr_reader :response, :html, :uri, :links, :page

  def self.create(addr) 
    
      encode(addr)
      if addr.empty?
        puts "Sorry, no scrape, couldn't encode addr to UTF-8!"
        return false
      end
    begin
      turi = URI.parse(addr)
    rescue Error
      puts "Sorry, No scrape. Bad URI"
      return false
    end

    if turi.host == nil || (VERBOTEN.any?{|reg| (addr =~ reg) != nil}) || (turi.host =~ /\.onion$/) == nil
      puts "Sorry, No scrape. Bad URI"
      return false
    else
      return new(addr)
    end

  end

  def self.encode(str)
    begin
      return str.encode("UTF-8", {:invalid => :replace, :undef => :replace})
    rescue UndefinedConversionError => err
      return ""
    end
  end


  def initialize(uri)
    @uri = URI.parse(uri)
    @links = []
    @page = {}
  end

  def get_response
    Net::HTTP.SOCKSProxy('localhost', 9050).start(uri.hostname, uri.port, {"User-Agent" => UA}) do |http|
      http.read_timeout = 3
      @response = http.get(uri.request_uri)
    end
  end

  def read
    @html ||= Nokogiri::HTML(@response.body)
  end

  def get_links
    html.css('a').each do |link|

      begin
        href = TorScraper.encode(link.attribute("href").value)
      rescue
        next
      end

      if !href.empty? && !(VERBOTEN.any?{|reg| (href =~ reg) != nil})
          links << { :href => href, :content => TorScraper.encode(link.content), :found_on => TorScraper.encode(uri.to_s)}
      end
    end
  end

  def page_description
    begin
      TorScraper.encode(html.css("meta[name=description]")[0].attribute("content").value)
    rescue
      ""
    end
  end

  def page_title
    begin
      TorScraper.encode(html.css("title")[0].content)
    rescue
      ""
    end
  end

  def get_content
    str = ""
    html.traverse do | node|
      if node.text? and not !node.text =~ /^\s*$/
          str << node.text
      end
    end
    str
  end

  def content
    @content ||= TorScraper.encode(get_content)
  end

  def get_page
    @page = {
      :site_name => uri.host,
      :href => uri.to_s,
      :title => page_title,
      :description => page_description,
      :content => content,
      :links => links
    }
  end

  def scrape
    get_response
    read
    get_links
    get_page
    page
  end

  class ArgumentError < StandardError
    def message
      "URI must include http:// to resolve hidden service urls"
    end
  end
end
