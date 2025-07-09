class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@anatomical.online'  # ← Updated domain
  layout "mailer"
end
