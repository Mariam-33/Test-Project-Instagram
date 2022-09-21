if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.asset_host = ActionController::Base.asset_host
  end

  ImageUploader

  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      # Need to set the storage here otherwise the class
      # overrides it in the uploader definition
      storage :file

      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
else
  CarrierWave.configure do |config|
    # Production setup
  end
end
