class IvrMainMenu

  def initialize

    @ivr_main_menu = 'Thank you for calling. Press one for business hours. Press two for customer service.'
    @repeat_message = 3
    @num_digits = 1
    @post = 'POST'
    @timeout = 1
    @ivr_options = '/ivr/options'
    @main_menu = '/ivr/main_menu'

  end

  attr_reader :ivr_main_menu, :repeat_message, :num_digits, :post, :timeout, :ivr_options, :main_menu

end
