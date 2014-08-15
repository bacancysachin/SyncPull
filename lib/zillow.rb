# Author -      Sachin Gevariya
# Description - Creating module to fetch response from zillow API
# Created on -  5 august 2014
# commit branch - json/2_setup_libraries (Setup libraries, services, objects, etc that will be used to access Zillow.com #2)

module Zillow
  	def self.get_deep_search_result(search_keyword)
      begin
        res = RestClient.get(AppConfig.application_constants["zillow_api_url"] + "?zws-id=" + AppConfig.application_constants["zillow_web_service_id"] + "&address=#{address}" + "&citystatezip=#{city}")
        res = Hash.from_xml(res)
        return res
      rescue Exception => e
        Rails.logger.info 'Bad Request' + e.message
        return
      end
    end
end