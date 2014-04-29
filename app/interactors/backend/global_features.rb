module Backend
  module GlobalFeatures
    extend self

    def all
      Feature.where(user_id: nil).map(&:name)
    end

    def set(features)
      Feature.where(user_id: nil).destroy_all
      features.each do |feature|
        Feature.create!(name: feature)
      end
    end
  end
end
