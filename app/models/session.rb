class Session

  attr_accessor :user
  attr_accessor :business
  attr_accessor :conference
  
  def initialize
    self.user = User.new
    self.business = Business.new
    self.conference = Conference.new
  end


end
