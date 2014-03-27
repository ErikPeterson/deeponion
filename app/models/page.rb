class Page < ActiveRecord::Base
	validates_presence_of :href
	validates_uniqueness_of :href, :scope => :site_id
	has_many :links, :dependent => :destroy
	belongs_to :site

	def links=(*links_arr)
		links_arr.flatten.each do |l|
			print "\n\t building link #{l[:href]}"

			begin
				URI.parse(l[:href])
			rescue URI::InvalidURIError => err
				puts err
				next
			end
			self.links.build(l)
			begin 
				self.save
				puts " - success!\n"
			rescue 
				puts " - failed :( \n"
				self.links.pop
			end
		end
	end

	def site_name=(name)
		site = Site.find_or_create_by(:host_name => name)
		self.site = site
	end

end