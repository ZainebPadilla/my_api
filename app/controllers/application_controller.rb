class ApplicationController < ActionController::API

  before_action :skip_session_storage

private

def skip_session_storage
  request.session_options[:skip] = true
end
end
