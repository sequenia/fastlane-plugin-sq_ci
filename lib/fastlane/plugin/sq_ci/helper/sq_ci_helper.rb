require 'fastlane/action'
require 'fastlane_core/ui/ui'

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
    end
  end
end
