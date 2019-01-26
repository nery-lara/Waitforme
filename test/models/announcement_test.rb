require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test 'announcement created' do
    annouce = Announcement.new
    assert_equal 'We are connecting you with the business', annouce.msg
  end
end
