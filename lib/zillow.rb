# Author -      Sachin Gevariya
# Description - Creating module to fetch response from zillow API
# Created on -  5 august 2014
# commit branch - json/2_setup_libraries (Setup libraries, services, objects, etc that will be used to access Zillow.com #2)

module Zillow
  	def self.get_deep_search_result(search_keyword)
      begin
        url = url = AppConfig.application_constants["zillow_api_url"] + "?zws-id=" + AppConfig.application_constants["zillow_web_service_id"] + "&address=#{search_keyword["address"]}" + "&citystatezip=#{search_keyword["city"]}"
        url = url.gsub(" ", "%2c")
        res = RestClient.get url
        res = Hash.from_xml(res)
        return res
      rescue Exception => e
        Rails.logger.info 'Bad Request' + e.message
        return
      end
    end
end