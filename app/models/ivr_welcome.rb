class IvrWelcome

  def initialize(user)

    @welcome_user = ''
    @ivr_main_menu = '/ivr/main_menu' + '/' + user

  end

  attr_reader :welcome_user, :ivr_main_menu

end
