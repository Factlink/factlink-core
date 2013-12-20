DeadUserTopic = Struct.new(:slug_title, :title) do
  def to_json(*a)
    {
      slug_tite: slug_title,
      title: title
    }.to_json
  end
end
