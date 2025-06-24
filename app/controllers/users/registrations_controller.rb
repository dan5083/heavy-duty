class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:is_trainer])
  end

  def after_sign_up_path_for(resource)
    if resource.persisted?
      # Create PersonalTrainer record if they checked the box
      if params[:user][:is_trainer] == '1'
        PersonalTrainer.create!(
          user: resource,
          name: resource.email.split('@').first.titleize
        )
      end

      dashboard_path
    else
      new_user_registration_path
    end
  end
end
