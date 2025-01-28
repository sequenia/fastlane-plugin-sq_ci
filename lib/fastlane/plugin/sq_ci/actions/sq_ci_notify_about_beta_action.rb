require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiNotifyAboutBetaAction < Action
      def self.run(params)
        app_version_string = other_action.sq_ci_get_app_version_string(
          main_target: params[:main_target]
        )

        message = Helper::SqCiHelper.new_beta_version_message(
          app_name: params[:app_name],
          app_version_string: app_version_string,
          installation_link: params[:installation_link]
        )

        other_action.sq_ci_send_telegram_message(
          message: message
        )
      end

      def self.description
        'Send message about new beta version'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :main_target,
            description: 'Name of main target',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_name,
            description: 'Name of application for notify',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :installation_link,
            description: 'Link to the app installation',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: 'SQ_CI_PROJECT_PATH',
            description: 'Path to project',
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
