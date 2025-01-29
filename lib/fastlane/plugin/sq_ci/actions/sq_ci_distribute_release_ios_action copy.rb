require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiDistributeReleaseIosAction < Action
      def self.run(params)
        project_path = params[:project_path]
        workspace_path = params[:workspace_path]

        ENV['FASTLANE_XCODEBUILD_SETTINGS_RETRIES'] = "10"
        ENV['FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT'] = "300"
        ENV['FASTLANE_XCODE_LIST_TIMEOUT'] = "300"

        if !workspace_path.nil? && workspace_path != ''
          ENV['GYM_WORKSPACE'] = workspace_path
        elsif !project_path.nil? && project_path != ''
          ENV['GYM_PROJECT'] = project_path
        end

        other_action.build_app(
          clean: params[:should_clear_project],
          scheme: params[:target_scheme],
          export_method: params[:export_method],
          xcargs: params[:build_args]
        )

        app_version_string = other_action.sq_ci_get_app_version_string(
          should_show_build_number: false
        )

        other_action.upload_to_app_store(
          submit_for_review: true,
          automatic_release: false,
          phased_release: true,
          force: true,
          skip_screenshots: params[:skip_screenshots],
          app_version: app_version_string,
          precheck_include_in_app_purchases: false
        )

      end

      def self.description
        'Build and send to review new version of app'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :target_scheme,
            description: 'Scheme for build',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :skip_screenshots,
            description: 'Should skip screenshots',
            optional: false,
            type: Boolean
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: 'SQ_CI_PROJECT_PATH',
            description: 'Path to project',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :workspace_path,
            env_name: 'SQ_CI_WORKSPACE_PATH',
            description: 'Path to workspace',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :export_method,
            env_name: 'SQ_CI_EXPORT_METHOD',
            description: 'Export method for build',
            optional: true,
            type: String,
            default_value: "app-store"
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_args,
            env_name: 'SQ_CI_BUILD_ARGS',
            description: 'Additional args for project build',
            optional: true,
            type: String,
            default_value: "-skipPackagePluginValidation -skipMacroValidation -allowProvisioningUpdates"
          ),
          FastlaneCore::ConfigItem.new(
            key: :should_clear_project,
            env_name: 'SQ_CI_SHOULD_CLEAR_PROJECT',
            description: 'Should clear project before build',
            optional: true,
            type: Boolean,
            default_value: true
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
