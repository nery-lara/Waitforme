require 'test_helper'

class VoiceResponseTest < ActiveSupport::TestCase
  test 'StartConference' do
    start = StartConference.new
    voice = VoiceResponse.new(start)
  end
end
