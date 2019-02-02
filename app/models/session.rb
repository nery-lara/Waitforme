class Session

  attr_accessor :user
  attr_accessor :business

  def initialize
    self.user = User.new
    self.business = Business.new
  end


end
