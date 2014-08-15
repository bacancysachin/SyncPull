namespace :stats_reminder do
	desc 'Sends service stats'
	task send_stats_reminder: :environment do
		StatsMailer.send_stats.deliver
	end
end