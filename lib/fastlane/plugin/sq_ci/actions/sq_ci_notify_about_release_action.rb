require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiNotifyAboutReleaseAction < Action
      def self.run(params)
        app_version_string = other_action.sq_ci_get_app_version_string

        message = Helper::SqCiHelper.notification_message(
          app_name: params[:app_name],
          app_version_string: app_version_string,
          app_type: "release",
          installation_links: []
        )

        other_action.sq_ci_send_telegram_message(
          message: message
        )
      end

      def self.description
        'Send message about release candidate'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :app_name,
            description: 'Name of application for notify',
            optional: false,
            type: String
          )
        ]
      end

      def self.return_value
        ''
      end

      def self.authors
        ['Semen Kologrivov']
      end

      def self.is_supported?(_)
        true
      end
    end
  end
end
