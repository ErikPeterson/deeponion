class Link
  attr_reader :href, :text, :found_on

    def initialize(href, text, found_on)
      @href = href
      @text = text
      @found_on = found_on
    end

    def found_on_uri
      @found_on_uri ||= URI.parse(self[:href])
    end

    def uri
      @uri ||= URI.parse(self[:href])
    end

    def full_path
      @full_path ||= get_full_path
    end


    def onion?
      full_path =~ /[[aA-zZ]|[0-9]]\.onion/
    end
private

  def get_full_path
    return href if !uri.host == nil
    parse_abs_path(found_on_uri, uri)
  end

  def self.parse_abs_path(parent_uri, uri)
    if parent_uri.path =~ /\/\z/ && uri.path =~ /\A\//
      "#{parent_uri.protocol}#{parent_uri.host}#{uri.path}"
    elsif parent_uri.path !=~ /.*\/*\.[aA-zZ]{1,5}\z/
      if uri.path =~ /\A\//
        "#{parent_uri.to_s}#{uri.path}"
      else
        "#{parent_uri.to_s}/#{uri.path}"
      end
    else
      if uri.path =~ /\A\//
        "#{parent_uri.to_s.gsub(/\/.*\z/, "")}#{uri.path}"
      else
        "#{parent_uri.to_s.gsub(/\/.*\z/, "/")}#{uri.path}"
      end
    end
  end

end
