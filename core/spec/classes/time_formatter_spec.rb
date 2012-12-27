require 'spec_helper'
require_relative '../../app/classes/time_formatter'

describe TimeFormatter do
  describe '#as_time_ago' do
    it 'returns the result of the rails time_ago_in_words helper' do
      time = mock
      formatable_time = mock
      in_words = mock

      TimeFormatter.should_receive(:formatable_time).with(time).and_return(formatable_time)
      TimeFormatter.should_receive(:time_ago_in_words).with(formatable_time).and_return(in_words)

      expect(TimeFormatter.as_time_ago time).to eq(in_words)
    end
  end

  describe '#formatable_time' do
    it 'returns the Time.at value of the passed time when it\'s more than one minute ago' do
      time = Time.now - 61

      expect(TimeFormatter.formatable_time time).to eq(time)
    end

    it 'returns the Time of one minute ago when the passed time is less than one minute ago' do
      now = Time.now

      Time.stub(:now).and_return(now)

      expect(TimeFormatter.formatable_time now-59).to eq(now-60)
    end
  end
end
