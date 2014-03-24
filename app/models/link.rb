class Link < ActiveRecord::Base
  validates_presence_of :href, :found_on, :full_path
  belongs_to :page

  before_create do
    self.full_path = get_full_path
  end

    def found_on_uri
      @found_on_uri ||= URI.parse(found_on)
    end

    def uri
      @uri ||= URI.parse(full_path)
    end


    def onion?
      full_path =~ /[[aA-zZ]|[0-9]]\.onion/
    end

    def full_path
      @full_path ||=get_full_path
    end



    def get_full_path
      return href if !(URI.parse(href).host == nil)
      Link.parse_abs_path(found_on_uri, href)
    end

    def self.parse_abs_path(parent_uri, path)
      (path[0] == "/") ? "#{parent_uri.scheme}://#{parent_uri.host}#{path}" : parse_relative(parent_uri, path)
    end

    def self.parse_relative(parent_uri, path)
      if parent_uri.path =~ /\/$/
        "#{parent_uri.scheme}://#{parent_uri.host}#{parent_uri.path}#{path}"
      else
        slice = parent_uri.path[0..(parent_uri.path =~ /\/\w+(\.\w+)?$/)]
        "#{parent_uri.scheme}://#{parent_uri.host}#{slice}#{path}"
      end
    end

end
