class Fact < OurOhm
  include Pavlov::Helpers

  def create
    require_saved_data

    result = super

    set_own_id_on_saved_data

    result
  end

  def to_s
    data.displaystring || ""
  end

  def created_at
    data.created_at.utc.to_s if data
  end

  reference :data, ->(id) { id && FactData.find(id) }

  #returns whether a given fact should be considered
  #unsuitable for usage/viewing
  def self.invalid(f)
    !f || !f.data_id
  end

  # For compatibility with DeadFact
  def site_url
    data.site_url
  end

  private

  def require_saved_data
    return if data_id

    localdata = FactData.new
    localdata.save
    # FactData now has an ID
    self.data = localdata
  end

  def set_own_id_on_saved_data
    data.fact_id = id
    data.save!
  end
end
