ActionDispatch::Callbacks.after do
  # Reload the factories
  return unless (Rails.env.development? || Rails.env.test?)

  FactoryGirl.factories.clear
  FactoryGirl.find_definitions
end
