# frozen_string_literal: true

# Cloudinary configuration
Cloudinary.config do |c|
  c.cloud_name = ENV['cloud_name']
  c.api_key = ENV['api_key']
  c.api_secret = ENV['api_secret']
  c.cdn_subdomain = true
end
