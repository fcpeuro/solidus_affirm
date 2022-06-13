# frozen_string_literal: true

require 'spree/core'

module SolidusAffirm
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_affirm'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.after_initialize do
      versions_without_api_custom_source_templates = Gem::Requirement.new('< 2.6')
      if versions_without_api_custom_source_templates.satisfied_by?(Spree.solidus_gem_version)
        require_dependency 'solidus_affirm/backward_compatibility_hacks/api_template'
      end
    end

    initializer "register_solidus_affirm_gateway", after: "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << 'SolidusAffirm::Gateway'
    end

    config.to_prepare do
      ActiveSupport.on_load :action_controller do |klass|
        next if klass.name == "ActionController::API"

        helper AffirmHelper
      end
    end

    if SolidusSupport.api_available?
      paths["app/views"] << "lib/views/api"
    end
  end
end
