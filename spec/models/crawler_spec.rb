require_relative '../spec_helper.rb'

describe TorCrawler do

  describe "#new" do
    it "takes a URL string as its single argument" do
      expect(TorCrawler.new("http://www.google.com").uri).to be_a(URI::Generic)
    end
    it "rejects urls without a scheme or hostname" do
      expect{TorCrawler.new("www.google.com")}.to raise_error(TorCrawler::ArgumentError)
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

    it "acts as the runner for the crawler, causing it to attempt to visit the uri and parse the links from the result" do
      tc = TorCrawler.new("http://www.google.com")
      tc.crawl
      expect(tc.links).to_not be_empty
    end

  end

end