require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

root_dir = File.dirname(__FILE__)
require_pattern = File.join(root_dir, '../app/**/*.rb')
failed = []

Dir.glob(require_pattern).each do |dependency|
  begin
    require_relative dependency.gsub("#{root_dir}/", '')
  rescue
    failed << dependency
  end
end

until failed.empty? do
  next_failed = []

  failed.each do |dependency|
    begin
      require_relative dependency.gsub("#{root_dir}/", '')
    rescue
      next_failed << dependency
    end
  end
  failed = next_failed
end

ActiveRecord::Base.default_timezone = :local
ActiveRecord::Base.logger = Logger.new(STDOUT)
