module ActiveAdmin
  class ManagedResource < ActiveRecord::Base
    self.table_name = "active_admin_managed_resources"

    has_many :permissions, dependent: :destroy
    validates :class_name, presence: true
    validates :action, presence: true

    def const
      @const ||= class_name.try(:safe_constantize)
    end

    def active?
      !const.nil?
    end

    def for_active_admin_page?
      class_name == "ActiveAdmin::Page"
    end

    def self.ransackable_attributes(_auth = nil)
      column_names + _ransackers.keys
    end

    def self.ransackable_associations(_auth = nil)
      reflect_on_all_associations.map { |a| a.name.to_s }
    end

    def self.ransortable_attributes(_auth = nil)
      ransackable_attributes
    end

    class << self
      def reload
        ActiveAdmin::PermissionReloader.reload
      end
    end
  end
end
