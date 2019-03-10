class IvrOptions

  def initialize(number)

    @user_input = number
    @input1 = '1'
    @business_hours = 'Our business hours are Monday to Friday 9 a m to 5 p m.'
    @input2 = '2'
    @please_wait = 'Thank you for calling, a representative will be with you shortly.'
    @return_main_menu = 'Sorry I did not understand. Returning to main menu.'
    @ivr_main_menu = '/ivr/main_menu'

  end

  attr_reader :user_input, :input1, :business_hours, :input2, :please_wait, :return_main_menu, :ivr_main_menu

end
