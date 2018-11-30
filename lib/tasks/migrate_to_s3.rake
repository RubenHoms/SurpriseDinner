require 'rake'
namespace :migrate_to_s3 do
  desc "Upload images to S3"
  task migrate: :environment do
    models = Review.all + Restaurant.all + Package.all
    models.each do |model|
      image = Dir["#{Rails.root}/public/system#{model.image.path}"].first
      if image.present?
        model.update!(image: File.open(image))
        puts "uploading #{image}"
      end
    end
  end
end