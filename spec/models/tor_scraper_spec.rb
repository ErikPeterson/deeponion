require_relative '../spec_helper.rb'

describe TorScraper do

  describe "#new" do
    it "takes a URL string as its single argument" do
      expect(TorScraper.new("http://www.google.com").uri).to be_a(URI::Generic)
    end
    it "rejects urls without a hostname" do
      expect{TorScraper.new("/some/path/to/a/file")}.to raise_error(TorScraper::ArgumentError)
    end
    it "sets the #uri attribute of the instance" do
      expect(TorScraper.new("http://www.google.com").uri.hostname).to eq("www.google.com")
    end
    it "sets the #links attribute of the instance to an empty array" do
      expect(TorScraper.new("http://www.google.com").links).to eq([])
    end
  end

  describe "#scrape" do

    let(:vanilla_scraper){
      TorScraper.new("http://localhost:8080/index.html").tap{|c| c.scrape}
    }
    let(:hs_scraper){
      TorScraper.new("http://p4u4zo2jzb6o6xu3.onion/index.html").tap{|c| c.scrape}
    }

    it "acts as the runner for the scraper, causing it to attempt to visit the uri and parse the page" do
      expect(vanilla_scraper.html).to be_a(Nokogiri::HTML::Document)
    end

    it "can resolve hidden services via tor" do
      expect(hs_scraper.html).to be_a(Nokogiri::HTML::Document)
    end

    it "gets a list of links on the page" do
      expect(hs_scraper.links).to_not be_empty
      expect(vanilla_scraper.links).to_not be_empty
    end

    it "gets basic information on the scraped page" do
      expect(hs_scraper.page[:href]).to eq("http://p4u4zo2jzb6o6xu3.onion/index.html")
      expect(vanilla_scraper.page[:href]).to eq("http://localhost:8080/index.html")
    end

  end

end
