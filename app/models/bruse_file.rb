class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags
	attr_accessor :tagname


	validates :name,     presence: true
	validates :filetype,     presence: true
	validates :meta,     presence: true


  def self.search(search)
    if search
      all.where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

end
