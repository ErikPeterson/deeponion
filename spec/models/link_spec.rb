require_relative '../spec_helper.rb'

describe Link do

  before(:each) do
    @local_relative_page_link = {
        :href=>"page-1.html",
        :content=>"A relative link to a file in the current directory",
        :found_on=>"http://p4u4zo2jzb6o6xu3.onion/index.html"}
    @local_absolute_page_link = {
        :href=>"/page-2.html",
        :content=>"An abs path to a file in the current directory",
        :found_on=>"http://p4u4zo2jzb6o6xu3.onion/index.html"}
    @local_relative_path_link = {
        :href=>"a/more/abstract/local/route",
        :content=>"An abstract relative path from the current directory",
        :found_on=>"http://p4u4zo2jzb6o6xu3.onion/index.html"}
    @local_absolute_path_link = {
        :href=>"/a/more/abstract/local/route",
        :content=>"An abstract absolute path from the current directory",
        :found_on=>"http://p4u4zo2jzb6o6xu3.onion/index.html"
        }
    @foreign_url_link = {
        :href=>"http://a4ua4b2azb4o6xu4.onion/index.html",
        :content=>"A link to an outside site",
        :found_on=>"http://p4u4zo2jzb6o6xu3.onion/index.html"
        }
  end

  describe "#new" do
    before(:each) do
      @ref = @foreign_url_link
      @link = Link.new(@ref[:href], @ref[:found_on], @ref[:content])
    end

    context "Link initializes with three arguments" do

      it "takes the path of a link as its first argument" do
        expect(@link.href).to eq(@ref[:href])
      end

      it "takes the url of the page the link appeared on as its second argument" do
        expect(@link.found_on).to eq(@ref[:found_on])
      end

      it "takes the content of the link element as its optional third argument" do
        expect(@link.content).to eq(@ref[:content])
      end

      it "will not initialize without either of its first two arguments" do
        expect{Link.new("Link text")}.to raise_error
      end

    end
  end


end
