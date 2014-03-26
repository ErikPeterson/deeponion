module Scrape
	def scrape_page(url)
			return false if Page.find_by(:href => url)
			scraper = TorScraper.new(url)
			begin
				scrape = scraper.scrape
			rescue StandardError, SocketError => err
				puts "#{url} not scraped due to error: #{err}"
				return false
			end
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
			if first_page = Page.find(first_page)

				q = first_page.links.to_a

				while !q.empty?  do
					q.shuffle!
					sleep = rand(5)
					cur_link = q.pop
					next if !cur_link.local?
					cur_scrape = scrape_page(cur_link.full_path)
					if cur_scrape
						cur_page = build_page(cur_scrape)
						if cur_page
							q.push(*cur_page.links.to_a)
						else
						    next
						end
					else
						next
					end
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
		outsiders = links.reject{|l| l.local? || !l.onion?}

		outsiders.each do |s|
			scrape_site(s.full_path)
			scrape_neighbors(s.full_path, depth - 1)
		end

	end

end