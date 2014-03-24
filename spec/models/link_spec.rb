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
      @link = Link.new(@ref)
    end

    context "Link initialzes with an attribute hash" do

      it "arg[:href] should contain the raw href attribute of the link" do
        expect(@link.href).to eq(@ref[:href])
      end

      it "arg[:found_on] should contain the full URL of the page the link was found on" do
        expect(@link.found_on).to eq(@ref[:found_on])
      end

      it "arg[:content] (optional) contains the content of the link element"  do
        expect(@link.content).to eq(@ref[:content])
      end

      it "will not initialize without href or found_on" do
          @link.found_on = nil

        expect(@link.save).to eq(false)
      end

    end

  end

  describe "instance methods" do

    before(:each) do

      @ref = @foreign_url_link
      @link = Link.new(@ref)
      @ref2 = @local_relative_path_link
      @rel_path_link = Link.new(@ref2)
      @ref3 = @local_absolute_page_link
      @abs_path_link = Link.new(@ref3)
    end

    context "#found_on_uri" do

      it "returns a parsed URI object based on the found_on argument" do
        expect(@link.found_on_uri.to_s).to eq(@ref[:found_on])
      end

    end

    context "#uri" do

      it "returns a parsed URI object based on the aboslute uri of the href argument" do
        
        expect(@link.uri.to_s).to eq(@ref[:href])
      end

      it "can derive the correct URI from relative paths and local absolute paths" do
        expect(@rel_path_link.uri.to_s).to eq("http://p4u4zo2jzb6o6xu3.onion/a/more/abstract/local/route")
        expect(@abs_path_link.uri.to_s).to eq("http://p4u4zo2jzb6o6xu3.onion/page-2.html")
      end

    end

  end


end
