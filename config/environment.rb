require 'bundler'
Bundler.require(:default)

require 'net/http'
require 'open-uri'
require 'socksify/http'

require_relative "../lib/crawler.rb"
require_relative "../lib/link.rb"
