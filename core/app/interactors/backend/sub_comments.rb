module Backend
  module SubComments
    def self.count(parent_id:)
      SubComment.where(parent_id: parent_id.to_s).count
    end
  end
end
