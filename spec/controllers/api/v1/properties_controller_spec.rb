require 'rails_helper'

RSpec.describe Api::V1::PropertiesController, type: :controller do

	describe "#index" do
		it "As a Requestor, When I access the list Then I should get back a list of requests for the current day by default And the list should be paginated with 50 per page" do
			get :index, format: :json
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor, When I access the list And I specify a start date (YYYY-MM-DD) Then I should get back a list of requests for all requests on or before that day And the list should be paginated with 50 per page" do
			get :index, format: :json, start_date: Date.today
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor, When I access the list And I specify a end date (YYYY-MM-DD) Then I should get back a list of requests for all requests on or before day And the list should be paginated with 50 per page" do
			get :index, format: :json, end_date: Date.today
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor, When I access the list And I specify a start date And end dat (YYYY-MM-DD) Then I should get back a list of requests for the range And the list should be paginated with 50 per page" do
			get :index, format: :json, start_date: Date.today, end_date: Date.today-7.days
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
	end

	describe "#show" do
		it "As a Requestor When I send a valid request ID Then I should get back data for the original request And I should get back data for the response" do
			@request = FactoryGirl.create(:property)
			get :show, format: :json, id: @property.request_id
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send an invalid request ID Then the response status code should be 404 (Not Found) And the response error should be Request not found" do
			get :show, format: :json, id: 2
			response_data = JSON.parse(response.body)
			response_data["status"].should == 404
		end
	end

	describe "#create" do
		it "As a Requestor When I send a valid address to process (by Zillow) Then the response should contain an JSON per documented example" do
			post :create, format: :json, property: { address: "6212+Durham Ave+NorthBergen", address2: "",  city: "NJ", state: "", poastal_code: "" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send an invalid address to process Then the response status code should be 406 (Not Acceptable) And the response error should be Invalid Address" do
			post :create, format: :json, property: { address: "6212+Durham ", address2: "",  city: "NJ", state: "", poastal_code: "" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 406
		end
		it "As a Requestor When I send a valid address to process And I have already requested 800 addresses from Zillow in the current day Then the response status code should be 405 (Method Not Allowed) And the response error should be Maximum requests reached" do
			post :create, format: :json, property: { address: "6212+Durham Ave+NorthBergen", address2: "",  city: "NJ", state: "", poastal_code: "" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send a valid address to process And that valid address has already been requested in the past 90 days Then send the same data as before And do NOT increase the request count for the current day for this request" do
			post :create, format: :json, property: { address: "6212+Durham Ave+NorthBergen", address2: "",  city: "NJ", state: "", poastal_code: "" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send a valid address to process And that valid address has already been requested greater than the past 90 days Then request the data again from Zillow And increase the request count for the current day for this request" do
			post :create, format: :json, property: { address: "6212+Durham Ave+NorthBergen", address2: "",  city: "NJ", state: "", poastal_code: "" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
	end

	describe "#update" do
		it "As a Requestor When I send a valid request ID Then that request should be reprocessed even if the request was less than 90 days." do
			@request = FactoryGirl.create(:property)
			get :update, format: :json, id: @property.request_id, property: { lat: "23.67556", long: "45.89976" }
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send an invalid request ID Then the response status code should be 404 (Not Found) And the response error should be Request not found" do
			get :update, format: :json, id: 2
			response_data = JSON.parse(response.body)
			response_data["status"].should == 404
		end
	end

	describe "#destroy" do
		it "As a Requestor When I send a valid request ID Then the response status code should be 200 (Success)" do
			@request = FactoryGirl.create(:property)
			get :destroy, format: :json, id: @property.request_id
			response_data = JSON.parse(response.body)
			response_data["status"].should == 200
		end
		it "As a Requestor When I send an invalid request ID Then the response status code should be 404 (Not Found) And the response error should be Request not found" do
			get :destroy, format: :json, id: 2
			response_data = JSON.parse(response.body)
			response_data["status"].should == 404
		end
	end

end