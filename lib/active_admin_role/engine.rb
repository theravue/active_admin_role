require "rails/engine"
require "active_admin_role/dsl"
require "active_admin_role/active_admin/dsl"

module ActiveAdminRole
  class Engine < ::Rails::Engine
    initializer "active_admin_role.dsl", after: "active_admin.load" do
      require "active_admin_role/dsl"
      if defined?(ActiveAdminRole::Dsl)
        [defined?(ActiveAdmin::DSL) ? ActiveAdmin::DSL : nil,
         defined?(ActiveAdmin::ResourceDSL) ? ActiveAdmin::ResourceDSL : nil,
         defined?(ActiveAdmin::PageDSL) ? ActiveAdmin::PageDSL : nil].compact.each do |klass|
          klass.include ActiveAdminRole::Dsl unless klass < ActiveAdminRole::Dsl
        end
      end
    end
  end
end

