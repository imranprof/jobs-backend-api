# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # currently requests allowed from all origins and resources for development purpose
    origins '*'
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
