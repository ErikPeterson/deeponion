class Page < ActiveRecord::Base
	validates_presence_of :href
	has_many :links
end