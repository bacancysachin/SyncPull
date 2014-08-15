class Property < ActiveRecord::Base

	before_create :save_request_id

	def save_request_id
		generate_request_id = (Time.now.to_i + (rand(10000000))).to_s(36) + ((Time.now - (rand(1000).year)).to_i + (rand(10000000))).to_s(36) 
		self.request_id  = generate_request_id
  	end

end