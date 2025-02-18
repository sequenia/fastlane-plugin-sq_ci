require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require_relative '../../../../sq_ci/ios_app/options'

module Fastlane
  module Actions
    class SqCiTestflightDistributeAction < Action
      def self.run(params)
        project_path = params[:project_path]
        workspace_path = params[:workspace_path]
        derived_data_path = params[:derived_data_path]

        ENV['FASTLANE_XCODEBUILD_SETTINGS_RETRIES'] = "10"
        ENV['FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT'] = "300"
        ENV['FASTLANE_XCODE_LIST_TIMEOUT'] = "300"

        if !workspace_path.nil? && workspace_path != ''
          ENV['GYM_WORKSPACE'] = workspace_path
        elsif !project_path.nil? && project_path != ''
          ENV['GYM_PROJECT'] = project_path
        end

        if !derived_data_path.nil? && derived_data_path != ''
          ENV['GYM_DERIVED_DATA_PATH'] = derived_data_path
        end

        latest_build_number = other_action.latest_testflight_build_number(
          initial_build_number: 0
        )

        other_action.increment_build_number(
          build_number: latest_build_number + 1,
          xcodeproj: params[:project_path],
          skip_info_plist: true
        )

        other_action.build_app(
          clean: params[:should_clear_project],
          scheme: params[:target_scheme],
          export_method: params[:export_method],
          xcargs: params[:build_args],
          skip_package_dependencies_resolution: params[:skip_package_dependencies_resolution]
        )

        testflight_testers_groups = params[:testflight_testers_groups]
        testflight_testers_groups_is_exist = !testflight_testers_groups.nil? && testflight_testers_groups != ''

        other_action.upload_to_testflight(
          notify_external_testers: testflight_testers_groups_is_exist,
          distribute_external: testflight_testers_groups_is_exist,
          groups: testflight_testers_groups.split(","),
          demo_account_required: params[:demo_account_required],
          beta_app_review_info: params[:beta_app_review_info],
          localized_app_info: params[:localized_app_info],
          localized_build_info: params[:localized_build_info]
        )
      end

      def self.description
        'Build and upload build to TestFlight'
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
            description: 'List of testflight testers groups separate with \',\'',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :export_method,
            description: 'Export method for build',
            optional: true,
            type: String,
            default_value: "app-store"
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_args,
            description: 'Additional args for project build',
            optional: true,
            type: String,
            default_value: "-skipPackagePluginValidation -skipMacroValidation"
          ),
          FastlaneCore::ConfigItem.new(
            key: :should_clear_project,
            description: 'Should clear project before build',
            optional: true,
            type: Boolean,
            default_value: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :skip_package_dependencies_resolution,
            description: 'Should skip packages resolving',
            optional: true,
            type: Boolean,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :derived_data_path,
            env_name: 'SQ_CI_DERIVED_DATA_PATH',
            description: 'Path to derived data folder',
            optional: true,
            type: String
          )
        ] +
          ::SqCi::IosApp::Options.options
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
