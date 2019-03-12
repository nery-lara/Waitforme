class IvrOptions

  def initialize(number, user)

    @user_input = number
    @input1 = '1'
    @business_hours = 'Our business hours are Monday to Friday 9 a m to 5 p m.'
    @input2 = '2'
    @please_wait = 'All of our agents are currently busy. Your call is important to us, please hold and your call will be answered in the order it was received'
    @return_main_menu = 'Sorry I did not understand, returning to main menu.'
    @ivr_main_menu = '/ivr/main_menu' + '/' + user

  end

  attr_reader :user_input, :input1, :business_hours, :input2, :please_wait, :return_main_menu, :ivr_main_menu

end
