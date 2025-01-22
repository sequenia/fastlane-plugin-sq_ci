require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'xcodeproj'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class SqCiHelper
      def self.new_beta_version_message(app_name:, app_version_string:, installation_link:)
        message = "Коллеги, сборка приложения '#{app_name}' #{app_version_string} готова к тестированию!"
        if !installation_link.nil? && installation_link != ''
          message = "#{message}\n\nСсылка на установку: #{installation_link}"
        end

        message
      end

      def self.add_target_attributes(target_name:, project_path:)
        project = Xcodeproj::Project.open(project_path)

        project.targets.each do |target|
          next unless target.name == target_name

          created_on_tools_version = { "CreatedOnToolsVersion" => "9.4.1" }
          target_attributes = project.root_object.attributes['TargetAttributes']
          target_attributes[target.uuid] = system_capabilities.merge(created_on_tools_version)
        end

        project.save
      end
    end
  end
end
