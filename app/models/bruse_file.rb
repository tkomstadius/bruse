class BruseFile < ActiveRecord::Base
  # relations
	has_and_belongs_to_many :tags
  belongs_to :identity

  ## validations
  # make sure file only added once from each identity
  validates :foreign_ref, uniqueness: { scope: :identity,
    message: 'That file appears to be added!' }
end
