class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags
	attr_accessor :tagname

	#validates_presence_of :name, :if => lambda  #{ |o| o.current_step == "shipping"}
	validates :name,     presence: true
	validates :filetype,     presence: true
	validates :meta,     presence: true

end
