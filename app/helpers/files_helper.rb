module FilesHelper
	def check(identity, current_user)
		return current_user.default_identity_id == nil ? true : identity.id == current_user.default_identity_id
	end
end
