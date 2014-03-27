module Scrape
	def scrape_page(url)
			uri = URI.parse(url)
			req_url = "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}"
			req_url += "?#{uri.query}" if uri.query
			return false if Page.find_by(:href => req_url)
			
			print "Attempting to scrape #{req_url}"
			scraper = TorScraper.create(req_url)
			if scraper
				begin
					scrape = scraper.scrape
				rescue StandardError, Error => err
					print " - not scraped due to error: #{err}" 
					return false
				end
			else
				print " - not scraped due to error: #{err}"
				return false
			end
			print " - success!\n"
			return scrape
	end

	def build_page(phash)
		begin
			record = Page.where(:href => phash[:href]).first if Page.where(:href => phash[:href]).count > 0

			record ||= Page.create(:href => phash[:href], :site_name => phash[:site_name], :title => phash[:title], :content => phash[:content])
			
			if record.persisted?
				record.links = phash[:links]

				return record
			else
				return false
			end
		rescue
			puts "le sigh, couldn't build page : ("
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
				q = first_page.links.to_a.reject(&:remote?)
				vn = []
				while !q.empty? do
					cur_link = q.pop
					next if vn.include?(cur_link.full_path)
					vn << cur_link.full_path

					cur_scrape = scrape_page(cur_link.full_path)

					if cur_scrape
						cur_page = build_page(cur_scrape)

						if cur_page
							cur_page.links.each do |link|
			
								if !vn.include?(link.full_path) && link.local?
									q << link
								end
							end
						end

					end
					
				end

			end
			
		end
	end

	def scrape_neighbors(url, depth)
		return if depth == 0
		site_uri = URI.parse(url)
		return if (site_uri.host =~ /[[aA-zZ]|[0-9]]\.onion/) == nil
		site = Site.find_or_create_by(:host_name => site_uri.host)

		if site.links.empty?
			scrape_site(url)
			site.reload
		end

		links = site.links.to_a

		outsiders = links.reject do |l| 
			l.local? || l.clear_web? || Page.where(:href => l.full_path).length > 0
		end.uniq{ |l| l.uri.host }
		
		outsiders.each do |s|
			puts "Attempting to scrape #{s.full_path}"
			scrape_neighbors(s.full_path, depth - 1)
		end

	end

end