namespace :tor do

	

	desc "Require the necessary ENV for writing to the dev database"
	task :db_env do
		ENV["RAILS_ENV"] ||= 'development'
		require File.expand_path("../../../config/environment", __FILE__)
		Bundler.require(:default)
	end

	desc "Build db rows based on a successful scrape"
	task :build_page, [:page] => [:db_env] do |t, args|
		require "pry"
		binding.pry
		phash = args[:page]
		record = Page.new(phash)
		if record.save
			Rake::Task["tor:scrape_log"].call("#{Time.now.to_s} - Page '#{record.title}' at #{record.href} successfully added with #{record.links.count} links", "persist.log")
		else
			Rake::Task["tor:scrape_log"].call("#{Time.now.to_s} - Page '#{record.title}' at #{record.href} failed to save because: '#{record.errors.full_messages.to_s}'", "persist.log")
		end
	end


	desc "Load the scraper environment file"
	task :scrape_env do
		require 'bundler'
		Bundler.require(:default)
		require 'net/http'
		require 'uri'
		require 'socksify/http'
		require 'active_record'
		require_relative "../tor_scraper.rb"
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
			`cd /users/erik/Dev/tor-crawl/hiddenserver`
			`thin start -a 127.0.0.1 -p 8080`
		end
	end

	desc "Logs the scrape"
	task :scrape_log, [:text, :file_path] => [:scrape_env] do |t, args|
		puts args[:file_path]
		file = File.open("lib/log/#{args[:file_path]}", "w+") do |f|
			f.puts args[:text]
			f.close
		end
	end

	desc "Scrape a page and get its links"
	task :scrape_page, [:url] => :scrape_env do |t, args|
		require "pry"
		url = args[:url]
		scraper = TorScraper.new(url)
		begin
			scraper.scrape
		rescue StandardError, SocketError => err
			puts "#{url} not scraped due to error: #{err}"
			return
		end
		Rake::Task["tor:scrape_log"].invoke("#{Time.now.to_s} - Successfully scraped page (#{url})", "scrape.log")
		Rake::Task["tor:build_page"].invoke(scraper.page)
	end

end