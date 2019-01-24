require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase 
  test 'announcement created' do
    annouce = Announcement.new
    assert_equal 'This is an announcement', annouce.msg
  end
end
