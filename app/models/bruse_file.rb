class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags, dependent: :destroy
  belongs_to :identity

	attr_accessor :tagname


	validates :name,     presence: true
	validates :filetype,     presence: true

  # def self.search(search)
  #   if search
  #     find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  #   else
  #     find(:all)
  #   end
  # end


  
end
