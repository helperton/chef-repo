module Helpers
	def self.auth
		  "--os-endpoint \"#{$endpoints['keystone']['admin']}\" --os-token \"#{$users['keystone']['admin']['token']}\""
	end
end

