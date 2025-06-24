class ClientMailer < ApplicationMailer
  default from: 'noreply@heavyduty.app'

  def welcome(user, temporary_password, personal_trainer)
    @user = user
    @temporary_password = temporary_password
    @trainer = personal_trainer
    @login_url = new_user_session_url

    mail(
      to: @user.email,
      subject: "Welcome to Heavy Duty - Your trainer #{@trainer.name} has added you"
    )
  end
end
