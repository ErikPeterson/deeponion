class Link < ActiveRecord::Base
  validates_presence_of :href, :found_on, :full_path
  validates_uniqueness_of :full_path, :scope => :page
  belongs_to :page
  belongs_to :site

  before_validation do
    @full_path ||= get_full_path
  end

    def found_on_uri
      URI.parse(found_on)
    end

    def uri
      URI.parse(full_path)
    end

    def local?
      found_on_uri.host == uri.host
    end

    def remote?
      found_on_uri.host != uri.host
    end

    def onion?
      (uri.host =~ /\.onion$/) != nil
    end

    def clear_web?
      (full_path =~ /[[aA-zZ]|[0-9]]\.onion/) == nil
    end

    def full_path
      @full_path ||= get_full_path
    end



    def get_full_path
      parsed_href = URI.parse(href)
      parent_uri = found_on_uri
      if parsed_href.host
        query = (parsed_href.query) ? "?#{parsed_href.query}" : ""
        return "#{parsed_href.scheme}://#{parsed_href.host}:#{parsed_href.port}#{parsed_href.path}#{query}" 
      elsif href[0] == "/"
        return "#{parent_uri.scheme}://#{parent_uri.host}:#{parent_uri.port}#{href}"
      else
        slice = (parent_uri.path =~ /\/\w+(\.\w+)?$/) ? parent_uri.path[0..(parent_uri.path =~ /\/\w+(\.\w+)?$/)] : "/"
        "#{parent_uri.scheme}://#{parent_uri.host}:#{parent_uri.port}#{slice}#{href}"
      end
    end

    # def self.parse_abs_path(parent_uri, path)
    #   (path[0] == "/") ? "#{parent_uri.scheme}://#{parent_uri.host}:#{parent_uri.port}#{path}" : parse_relative(parent_uri, path)
    # end

    # def self.parse_relative(parent_uri, path)
    #   if parent_uri.path =~ /\/$/
    #     "#{parent_uri.scheme}://#{parent_uri.host}:#{parent_uri.port}#{parent_uri.path}#{path}"
    #   else
    #     slice = (parent_uri.path =~ /\/\w+(\.\w+)?$/) ? parent_uri.path[0..(parent_uri.path =~ /\/\w+(\.\w+)?$/)] : "/"
    #     "#{parent_uri.scheme}://#{parent_uri.host}:#{parent_uri.port}#{slice}#{path}"
    #   end
    # end

end
