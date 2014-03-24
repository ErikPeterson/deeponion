namespace :tor do

	desc "Load the scraper environment file"	
	task :scrape_env do
		require 'bundler'
		Bundler.require(:default)
		require 'net/http'
		require 'uri'
		require 'socksify/http'
		require 'active_record'
		require_relative "../lib/tor_scraper.rb"
	end

	desc "Start the Tor process"
	task :start_tor do
		TOR_PID = fork do
			`tor`
		end
	end

	desc "Start the hidden service server"
	task :start_server do
		SERVER_PID = fork do
			`cd /users/erik/tev/tor-crawl/hiddenserver`
			`thin start -a 127.0.0.1 -p 8080`
		end
	end

end