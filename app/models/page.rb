class Page < ActiveRecord::Base
	validates_presence_of :href
	validates_uniqueness_of :href
	has_many :links
	belongs_to :site

	def links=(*links)
		links.flatten.each do |link|
			self.links.build(link)
		end
	end

	def site_name=(name)
		site = Site.find_by(:host_name => name)
		self.site = site if site
	end

end