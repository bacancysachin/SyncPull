require 'ostruct'
require 'yaml'
if File.exists?(File.join(Rails.root, 'config', 'application.yml'))
  file = File.join(Rails.root, 'config', 'application.yml')
  users_app_config = YAML.load_file file
end

config_hash = users_app_config || {}

unless defined?(AppConfig)
  ::AppConfig = OpenStruct.new config_hash
else
  # orig_hash   = AppConfig.marshal_dump
  # merged_hash = config_hash.merge(orig_hash)
  # AppConfig   = OpenStruct.new merged_hash
end