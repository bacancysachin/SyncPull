class Api::V1::PropertiesController < ApplicationController
	respond_to :josn
	include Zillow

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

	def create
		property_limit_for_day = Property.where(created_at: Date.today).all
		if property_limit_for_day.count >= 800 
			response = Zillow.get_deep_search_result(params)
			response_status = response["searchresults"]["message"] if response
			property_info = response["searchresults"]["response"]["results"]["result"] if response
			if (response_status["code"].eql?("0") && response_status["text"].eql?("Request successfully processed"))
				property = Property.where(lat: property_info["address"]["latitude"], lng: property_info["address"]["longitude"], created_at: Time.now..Time.now-90.day).first
				if property
					render json: { status: 200, message: "Request successfull", property: property.as_json }
				else
					property = Property.create(requested_at: Time.now, lat: property_info["address"]["latitude"], lng: property_info["address"]["longitude"], year_built: property_info["yearBuilt"], usecode: property_info["useCode"], last_sold_on: property_info["lastSoldDate"], last_sold_price: property_info["lastSoldPrice"], tax_assesment_year: property_info["taxAssessmentYear"], tax_assesment_amount: property_info["taxAssessment"], zestimate_price: property_info["zestimate"]["amount"], zestimate_value_range_high: property_info["zestimate"]["valuationRange"]["hign"], zestimate_value_range_low: property_info["zestimate"]["valuationRange"]["low"], zastimate_last_updated_on: property_info["zestimate"]["last_updated"], lot_size: property_info["lotSizeSqFt"], house_size: property_info["localRealEstate"]["region"]["zindexValue"], zpid: property_info["zpid"], processed: true)
					if property
						render json: { status: 200, message: "Request successfull", property_info: property.as_json }
					else
						render json: { status: 422, message: "Unprocessable Entity" }
					end
				end
			else
				render json: { response: response }
			end
		else
			render json: { status: 405, message: "Maximum requests reached" }
		end
	end

	def show
		property = Property.find_by_request_id[params[:id]]
		if property
			render json: { status: 200, message: "Request successfull", property: property.as_json }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end

	def update
		property = Property.where(request_id: params[:id], created_at: Time.now..Time.now-90.day).first
		if property
			property = property.update_attributes(params[:property])
			render json: { status: 200, message: "Request successfull", property: property.as_json }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end

	def destroy
		property = Property.find_by_request_id(params[:id])
		if property
			property.destroy
			render json: { status: 200, message: "Request successfull" }
		else
			render json: { status: 404, message: "Request not found"}
		end
	end



end