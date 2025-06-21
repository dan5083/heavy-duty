class PwaController < ApplicationController
  # Skip CSRF protection for PWA files
  skip_before_action :verify_authenticity_token
  
  def manifest
    render 'pwa/manifest', formats: [:json]
  end

  def service_worker
    # Set proper headers for service worker
    response.headers['Content-Type'] = 'application/javascript'
    response.headers['Service-Worker-Allowed'] = '/'
    
    render 'pwa/service_worker', formats: [:js]
  end
end
