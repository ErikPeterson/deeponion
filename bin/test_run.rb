#!/usr/bin/env ruby

require_relative "../config/environment.rb"


crawler = TorCrawler.new("http://p4u4zo2jzb6o6xu3.onion/index.html")
links = []
crawler.crawl

crawler.links.each do |link|
  puts link[:href]
  puts link[:content]
  puts link[:found_on]
end
