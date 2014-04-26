module Helpers
	def self.auth
		  "--os-endpoint \"#{$endpoints['keystone']}\" --os-token \"#{$users['keystone']['admin']['token']}\""
	end
end

