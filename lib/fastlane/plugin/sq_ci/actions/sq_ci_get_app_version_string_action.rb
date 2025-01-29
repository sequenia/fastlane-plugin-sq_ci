require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiGetAppVersionStringAction < Action
      def self.run(params)
        platform = lane_context[SharedValues::PLATFORM_NAME] || lane_context[SharedValues::DEFAULT_PLATFORM]
        should_show_build_number = params[:should_show_build_number]
        if platform == :ios
          version_number = other_action.get_version_number(
            xcodeproj: params[:project_path],
            target: params[:main_target]
          )

          build_number = other_action.get_build_number(
            xcodeproj: params[:project_path]
          )

          should_show_build_number ? "#{version_number}(#{build_number})" : version_number
        elsif platform == :android
          gradle_file_path = Helper::SqCiHelper.get_gradle_file_path(params[:gradle_file_path])
          version_name = Helper::SqCiHelper.read_key_from_gradle_file(gradle_file_path, "versionName")
          version_code = Helper::SqCiHelper.read_key_from_gradle_file(gradle_file_path, "versionCode")
          should_show_build_number ? "#{version_name}(#{version_code})" : version_name
        else
          UI.user_error!("Platform not specified!")
        end
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
            key: :should_show_build_number,
            description: 'Should add build number into version number',
            optional: true,
            default_value: true
            type: Boolean
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
