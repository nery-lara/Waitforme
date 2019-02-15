class IvrWelcome

  def initialize

    @welcome_user = 'Thank you for calling.'
    @ivr_main_menu = '/ivr/main_menu'

  end

  attr_reader :welcome_user, :ivr_main_menu

end
