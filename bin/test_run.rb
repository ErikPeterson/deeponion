#!/usr/bin/env ruby

require_relative "../config/environment.rb"

`python -m SimpleHTTPServer`

crawler = TorCrawler.new("http://p4u4zo2jzb6o6xu3.onion/")

crawler.crawl

crawler.links.each do |link|
  puts link[:href]
  puts link[:text]
  puts link[:found_on]
end
