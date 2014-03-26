module Scrape
	def scrape_page(url)
			uri = URI.parse(url)
			req_url = "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}"
			req_url += uri.query if uri.query
			return false if Page.find_by(:href => req_url)
			
			print "Attempting to scrape #{req_url}"
			scraper = TorScraper.new(req_url)
			begin
				scrape = scraper.scrape
			rescue StandardError, SocketError => err
				print " - not scraped due to error: #{err}"
				return false
			end
			print " - success!\n"
			return scrape
	end

	def build_page(phash)
			return false if Page.find_by(:href => phash[:href])
			record = Page.new(phash)
			if record.save
				return record
			else
				return false
			end
	end

	def scrape_site(url)
		site_uri = URI.parse(url)
		site = Site.find_or_create_by(:host_name => site_uri.host)
		first_scrape = scrape_page(url)

		if first_scrape
			first_page = build_page(first_scrape)

			if first_page

				q = first_page.links.to_a

				while !q.empty? do

					cur_link = q.pop
					##big ol code smell right here
				end

			end
			
		end
	end

	def scrape_neighbors(url, depth)
		return if depth == 0
		site_uri = URI.parse(url)
		site = Site.find_or_create_by(:host_name => site_uri.host)
		if site.links.empty?
			scrape_site(url)
			site.reload
		end
		links = site.links.to_a
		outsiders = links.reject{|l| l.local? || !l.onion? || Page.find_by(:href => l.full_path)}
		binding.pry
		outsiders.each do |s|
			puts "Attempting to scrape #{s.full_path}"
			scrape_neighbors(s.full_path, depth - 1)
		end

	end

end