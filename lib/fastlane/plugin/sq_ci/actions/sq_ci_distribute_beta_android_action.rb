require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiDistributeBetaAndroidAction < Action
      def self.run(params)
        build_type = params[:build_type]
        flavor = params[:flavor]
        project_folder = params[:project_folder]

        other_action.gradle(
          task: 'assemble',
          flavor: flavor,
          build_type: build_type,
          project_dir: project_folder
        )

        other_action.sq_ci_upload_file_to_s3(
          file_path: lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]
        )
      end

      def self.description
        'Build and upload beta version of Android application'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :flavor,
            description: 'Flavor for build',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_type,
            description: 'Build type of application',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_folder,
            description: 'Folder of project',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :distribute_type,
            description: 'Type of distribution. Available values: apk, google_play, app_gallery, ru_store',
            optional: false,
            type: String
          )
        ]
      end

      def self.return_type
        :string
      end

      def self.return_value
        'Link for download build'
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
