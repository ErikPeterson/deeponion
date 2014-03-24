ENV['ENV'] ||= "development"

require 'bundler'
Bundler.require(:default)

require 'net/http'
require 'uri'
require 'socksify/http'
require 'active_record'

require_relative "../lib/tor_scraper.rb"

TCPSocket::socks_server = "127.0.0.1"
TCPSocket::socks_port = 9050
