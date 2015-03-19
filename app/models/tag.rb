class Tag < ActiveRecord::Base
	has_and_belongs_to_many :bruse_files
  attr_accessor :file_id


  def self.search(search)
    if search
      all.where('tags.name LIKE ?', "%#{search}%")
    else
      all
    end
  end

end