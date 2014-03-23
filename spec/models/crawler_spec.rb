require_relative '../spec_helper.rb'

describe TorCrawler do

  describe "#new" do
    it "takes a URL string as its single argument" do
      expect(TorCrawler.new("http://www.google.com").uri).to be_a(URI::Generic)
    end
    it "rejects urls without a hostname" do
      expect{TorCrawler.new("/some/path/to/a/file")}.to raise_error(TorCrawler::ArgumentError)
    end
    it "sets the #uri attribute of the instance" do
      expect(TorCrawler.new("http://www.google.com").uri.hostname).to eq("www.google.com")
    end
    it "sets the #links attribute of the instance to an empty array" do
      expect(TorCrawler.new("http://www.google.com").links).to eq([])
    end
  end

  describe "#crawl" do

    let(:vanilla_crawler){
      TorCrawler.new("http://localhost:8080/index.html").tap{|c| c.crawl}
    }
    let(:hs_crawler){
      TorCrawler.new("http://p4u4zo2jzb6o6xu3.onion/index.html").tap{|c| c.crawl}
    }

    it "acts as the runner for the crawler, causing it to attempt to visit the uri and parse the page" do
      expect(vanilla_crawler.html).to be_a(Nokogiri::HTML::Document)
    end

    it "can resolve hidden services via tor" do
      expect(hs_crawler.html).to be_a(Nokogiri::HTML::Document)
    end

    it "gets a list of links on the page" do
      expect(hs_crawler.links).to_not be_empty
      expect(vanilla_crawler.links).to_not be_empty
    end

    it "gets basic information on the crawled page" do
      expect(hs_crawler.page[:url]).to eq("http://p4u4zo2jzb6o6xu3.onion/index.html")
      expect(vanilla_crawler.page[:url]).to eq("http://localhost:8080/index.html")
    end

  end

end
