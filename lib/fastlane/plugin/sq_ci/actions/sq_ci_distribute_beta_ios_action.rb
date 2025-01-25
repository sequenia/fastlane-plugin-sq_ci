require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiDistributeBetaIosAction < Action
      def self.run(params)
        ENV['FASTLANE_XCODEBUILD_SETTINGS_RETRIES'] = "10"
        ENV['FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT'] = "300"
        ENV['FASTLANE_XCODE_LIST_TIMEOUT'] = "300"

        other_action.build_app(
          project: params[:project_path],
          workspace: params[:workspace_path],
          clean: params[:should_clear_project],
          scheme: params[:target_scheme],
          export_method: params[:export_method],
          xcargs: params[:build_args]
        )

        testflight_testers_groups = params[:testflight_testers_groups]
        testflight_testers_groups_is_exist = testflight_testers_groups.nil? && testflight_testers_groups != ''

        other_action.upload_to_testflight(
          notify_external_testers: testflight_testers_groups_is_exist,
          distribute_external: testflight_testers_groups_is_exist,
          groups: testflight_testers_groups,
          demo_account_required: params[:demo_account_required],
          beta_app_review_info: params[:beta_app_review_info],
          localized_app_info: params[:localized_app_info],
          localized_build_info: params[:localized_build_info]
        )
      end

      def self.description
        'Build and upload beta version to TestFlight'
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
            key: :demo_account_required,
            description: 'Is demo account required for review in Testflight',
            optional: false,
            type: Boolean
          ),
          FastlaneCore::ConfigItem.new(
            key: :beta_app_review_info,
            description: 'App review info for Testflight',
            optional: false,
            type: Object
          ),
          FastlaneCore::ConfigItem.new(
            key: :localized_app_info,
            description: 'App info for Testflight',
            optional: false,
            type: Object
          ),
          FastlaneCore::ConfigItem.new(
            key: :localized_build_info,
            description: 'Build info for Testflight',
            optional: false,
            type: Object
          ),
          FastlaneCore::ConfigItem.new(
            key: :testflight_testers_groups,
            env_name: 'SQ_CI_TESTFLIGHT_TESTERS_GROUPS',
            description: 'List of testflight testers groups',
            optional: true,
            type: String
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
