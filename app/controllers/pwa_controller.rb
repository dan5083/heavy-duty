class PwaController < ApplicationController
  def manifest
    respond_to do |format|
      format.json { render template: 'pwa/manifest.json.erb' }
    end
  end

  def service_worker
    respond_to do |format|
      format.js { render template: 'pwa/service-worker.js', content_type: 'application/javascript' }
    end
  end
end
