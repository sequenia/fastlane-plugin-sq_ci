require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiSetupCodeSigningIosAction < Action
      def self.run(params)
        ENV['MATCH_PASSWORD'] = params[:certificates_password]
        other_action.sync_code_signing(
          type: params[:code_signing_type],
          git_url: params[:certificates_repo],
          keychain_name: params[:keychain_name],
          keychain_password: params[:keychain_password],
          skip_confirmation: true,
          app_identifier: params[:targets].map { |_, app_id| app_id },
          force: false,
          verbose: false
        )

        params[:targets].each do |target, app_identifier|
          other_action.update_code_signing_settings(
            use_automatic_signing: false,
            path: params[:project_path],
            bundle_identifier: app_identifier,
            profile_name: lane_context[SharedValues::MATCH_PROVISIONING_PROFILE_MAPPING][app_identifier],
            code_sign_identity: params[:code_sign_identity],
            targets: [target],
            build_configurations: [params[:build_configuration]]
          )
        end
      end

      def self.description
        'Setup code signing for iOS application'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :targets,
            description: 'Targets in project',
            optional: false,
            type: Object
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_configuration,
            description: 'Build configuration to update profiles',
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
            key: :code_signing_type,
            env_name: 'SQ_CI_CODE_SIGNING_TYPE',
            description: 'Targets in project',
            optional: true,
            type: String,
            default_value: 'appstore'
          ),
          FastlaneCore::ConfigItem.new(
            key: :code_sign_identity,
            env_name: 'SQ_CI_CODE_SIGN_IDENTITY',
            description: 'Code sign identity for profile',
            optional: true,
            type: String,
            default_value: 'iPhone Distribution'
          ),
          FastlaneCore::ConfigItem.new(
            key: :keychain_name,
            env_name: 'SQ_CI_KEYCHAIN_NAME',
            description: 'Keychain name for storing certificates',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :keychain_password,
            env_name: 'SQ_CI_KEYCHAIN_PASSWORD',
            description: 'Password for keychain for storing certificates',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :certificates_repo,
            env_name: 'SQ_CI_CERTIFICATES_REPO',
            description: 'Repository for store certificates and profiles',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :certificates_password,
            env_name: 'SQ_CI_CERTIFICATES_PASSWORD',
            description: 'Password for certificates and profiles storage',
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
