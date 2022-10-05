# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3001', '127.0.0.1:3001'
    resource '/stories', headers: :any, methods: [:get]
    resource '/relationships', headers: :any, methods: [:get]
  end
end


