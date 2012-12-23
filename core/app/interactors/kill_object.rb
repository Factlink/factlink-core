require 'ostruct'

module KillObject
  def self.dead_object(name, fields)
    self.class.send(:define_method, name) do |*args|
      alive_object, extra_fields = *args
      kill alive_object, fields, extra_fields || {}
    end
  end

  dead_object :conversation,
    [:id, :fact_data_id, :fact_id, :recipient_ids]
  dead_object :message,
    [:id, :created_at, :updated_at, :content, :sender_id]
  dead_object :user,
    [:id, :name, :username, :location, :biography,
     :gravatar_hash, :email, :receives_mailed_notifications]
  dead_object :channel,
    [:type, :title, :id, :has_authority?,
     :slug_title, :created_by_id, :inspectable?,
     :editable?]
  dead_object :comment,
    [:id, :created_by, :created_at, :content, :type,
     :fact_data, :sub_comment_count]
  dead_object :sub_comment,
    [:id, :created_by, :created_by_id, :created_at, :content, :parent_id]
  dead_object :site,
    [:id, :url]
  dead_object :topic,
    [:title, :slug_title]
  dead_object :fact_relation,
    [:id, :type, :fact, :from_fact, :created_by, :percentage,
     :opinion, :sub_comments_count, :deletable?]


  def self.kill alive_object, take_fields, extra_fields={}
    hash = {}
    take_fields.each do |key|
      hash[key] = alive_object.send(key) if alive_object.respond_to? key
    end
    open_struct = OpenStruct.new(hash.merge extra_fields)

    open_struct.send(:define_singleton_method, :to_json) do |*args|
      table.to_json(*args)
    end

    open_struct
  end
end
