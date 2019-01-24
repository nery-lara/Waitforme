require 'test_helper'

class AnsweredTest < ActiveSupport::TestCase 
  test 'Answered created' do
    answer = Answered.new
    assert_equal 'you answered the call', answer.msg
  end

  test 'HangupOnStar' do
    answer = Answered.new
    assert_equal 'true', answer.hangupOnStar
  end
end
