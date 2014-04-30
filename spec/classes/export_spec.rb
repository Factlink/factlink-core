require 'spec_helper'

describe Export do
  include PavlovSupport

  it '#export' do
    dump_file_path = File.expand_path('../../../db/dump.rb', __FILE__)

    require dump_file_path

    expect(Export.new.export).to eq File.read(dump_file_path)
  end
end
