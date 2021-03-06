class Api::V1::PropertiesController < ApplicationController
	respond_to :josn
	include Zillow

	# Author -      Sachin Gevariya
	# Description - It fetchs the requestes on the basis of provided parameters
	# Created on -  5 august 2014
	# commit branch - json/json/3_Address_CRUD (Address CRUD)
	
	def index		
		if params[:start_date].present?
			properties = Property.paginate(page: params[:page], per_page: 50).where(created_at: params[:start_date].to_date..Time.now+1.day)
		elsif params[:end_date].present?
			properties = Property.paginate(page: params[:page], per_page: 50).where(created_at: params[:end_date].to_date..Time.now-1.day)
		elsif(params[:start_date].present? && params[:end_date].present?)
			properties = Property.paginate(page: params[:page], per_page: 50).where(created_at: params[:start_date].to_date..params[:end_date].to_date)
		else
			properties = Property.paginate(page: params[:page], per_page: 50).where(created_at: Time.now..Time.now-1.day)
		end
		render json: { status: 200, message: "Request successfull", properties: properties.as_json }
	end

	# Author -      Sachin Gevariya
	# Description - Create method fetches property details from Zillow API and saved the required data into database
	# Created on -  5 august 2014
	# commit branch - json/json/3_Address_CRUD (Address CRUD)

	def create
		property_limit_for_day = Property.where(created_at: Date.today).all
		if property_limit_for_day.count <= 800 
			response = Zillow.get_deep_search_result(params)
			if response.present?
				response_status = response["searchresults"]["message"] if response
				if (response_status["code"].eql?("0") && response_status["text"].eql?("Request successfully processed"))
					property_info = response["searchresults"]["response"]["results"]["result"]
					property = Property.where(lat: property_info["address"]["latitude"], lng: property_info["address"]["longitude"], created_at: Time.now..Time.now-90.day).first
					if property
						render json: { status: 200, message: "Request successfull", property: property.as_json }
					else
						property = Property.create(requested_at: Time.now, lat: property_info["address"]["latitude"], lng: property_info["address"]["longitude"], year_built: property_info["yearBuilt"], usecode: property_info["useCode"], last_sold_on: Date.strptime(property_info["lastSoldDate"], "%m/%d/%Y"), last_sold_price: property_info["lastSoldPrice"], tax_assesment_year: property_info["taxAssessmentYear"], tax_assesment_amount: property_info["taxAssessment"], zestimate_price: "", zestimate_value_range_high: "", zestimate_value_range_low: "", zastimate_last_updated_on: Date.strptime(property_info["zestimate"]["last_updated"], "%m/%d/%Y"), lot_size: property_info["lotSizeSqFt"], house_size: property_info["localRealEstate"]["region"]["zindexValue"], zpid: property_info["zpid"], processed: true)
						if property
							render json: { status: 200, message: "Request successfull", property_info: property.as_json }
						else
							render json: { status: 422, message: "Unprocessable Entity" }
						end
					end
				else
					render json: { status: response_status["code"], message: response_status["text"] }
				end
			else
				render json: { status: 406, message: "Invalid address" }
			end
		else
			render json: { status: 405, message: "Maximum requests reached" }
		end
	end

	# Author -      Sachin Gevariya
	# Description - It fetchd the request details of a valid request
	# Created on -  5 august 2014
	# commit branch - json/json/3_Address_CRUD (Address CRUD)

	def show
		property = Property.find_by_request_id(params[:id])
		if property
			render json: { status: 200, message: "Request successfull", property: property.as_json }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end

	# Author -      Sachin Gevariya
	# Description - Updates a valid request
	# Created on -  5 august 2014
	# commit branch - json/json/3_Address_CRUD (Address CRUD)

	def update
		property = Property.where(request_id: params[:id], created_at: Time.now..Time.now-90.day).first
		if property
			property = property.update_attributes(params[:property])
			render json: { status: 200, message: "Request successfull", property: property.as_json }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end

	# Author -      Sachin Gevariya
	# Description - Deletes a valid request
	# Created on -  5 august 2014
	# commit branch - json/json/3_Address_CRUD (Address CRUD)

	def destroy
		property = Property.find_by_request_id(params[:id])
		if property
			property.destroy
			render json: { status: 200, message: "Request successfull" }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end

	# Author -      Sachin Gevariya
	# Description - Get service stats
	# Created on -  5 august 2014
	# commit branch - json/5_Service_status_info

	def service_stats
		request_today = Property.where(created_at: Date.today).count
		request_remaining = Property.where(processed: false).count
		last_request = Property.last.created_at.to_i
		requests_yesterday = Property.where(created_at: Date.today-1.day).count
		requests_this_week = Property.where(created_at: Date.today..Date.today-7.days).count
		requests_last_week = Property.where(created_at: Date.today-7.days..Date.today-14.days).count
		requests_this_month = Property.where(created_at: Date.today..Date.today-30.days).count
		requests_last_month = Property.where(created_at: Date.today-30.days..Date.today-60.days).count
		render json: { status: 200, response: { request_today: request_today, request_remaining: request_remaining,
					last_request: last_request, requests_yesterday: requests_yesterday, requests_this_week: requests_this_week,
					requests_last_week: requests_last_week, requests_this_month: requests_this_month, requests_last_month: requests_last_month }}
	end

end