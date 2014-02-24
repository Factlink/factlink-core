class RemoveInvalidFactData < Mongoid::Migration
  def self.up
    FactData.all.each do |fd|
      fd.destroy if FactData.invalid(fd)
    end
  end

  def self.down
  end
end
