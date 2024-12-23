require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiGetAppVersionStringAction < Action
      def self.run(params)
        version_number = other_action.get_version_number(
          xcodeproj: params[:project_path],
          target: params[:main_target]
        )

        build_number = other_action.get_build_number(
          xcodeproj: params[:project_path]
        )

        "#{version_number}(#{build_number})"
      end

      def self.description
        'Get string with current app version'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :main_target,
            description: 'Name of main target',
            env_name: 'SQ_CI_MAIN_TARGET',
            optional: false,
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
