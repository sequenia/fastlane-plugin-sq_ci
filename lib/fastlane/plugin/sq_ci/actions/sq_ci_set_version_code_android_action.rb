require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiSetVersionCodeAndroidAction < Action
      def self.run(params)
        gradle_file_path = Helper::SqCiHelper.get_gradle_file_path(params[:gradle_file_path])
        new_version_code = Helper::SqCiHelper.get_new_version_code(gradle_file_path, params[:version_code])

        Helper::SqCiHelper.save_key_to_gradle_file(gradle_file_path, "versionCode", new_version_code)
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
            key: :version_code,
            description: 'Version code to set',
            optional: false,
            type: String
          ),
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
          ),
          FastlaneCore::ConfigItem.new(
            key: :gradle_file_path,
            env_name: 'SQ_CI_GRADLE_FILE_PATH',
            description: 'Path to build.gradle file',
            default_value: "app/build.gradle",
            optional: true,
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
