class StatsMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_stats
  	@stats = RestClient.get(root_url+"/api/v1/properties/service_stats.json")
  	mail(to: "wes@mortarstone.com", subject: "Request Statistics")
  end

end