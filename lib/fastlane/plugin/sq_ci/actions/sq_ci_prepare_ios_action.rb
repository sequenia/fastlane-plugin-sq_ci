require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiPrepareIosAction < Action
      def self.run(params)
        keychain_path = "~/Library/Keychains/#{params[:keychain_name]}-db"

        if `find ~/Library/Keychains -type f -print | grep '#{params[:keychain_name]}'`.strip.empty?
          other_action.create_keychain(
            lock_when_sleeps: false,
            name: params[:keychain_name],
            password: params[:keychain_password]
          )
        end

        other_action.unlock_keychain(
          path: keychain_path,
          password: params[:keychain_password]
        )

        other_action.app_store_connect_api_key(
          key_id: params[:app_store_connect_key_id],
          issuer_id: params[:app_store_connect_key_issuer_id],
          key_filepath: params[:app_store_connect_key_path],
          in_house: false,
          duration: params[:app_store_connect_session_duration]
        )

        latest_build_number = other_action.latest_testflight_build_number(
          initial_build_number: 0
        )

        other_action.increment_build_number(
          build_number: latest_build_number + 1,
          xcodeproj: params[:project_path],
          skip_info_plist: true
        )
      end

      def self.description
        'Prepare environment for iOS app build and distributuion'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: 'SQ_CI_PROJECT_PATH',
            description: 'Path to project',
            optional: false,
            type: String
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
            key: :app_store_connect_key_id,
            env_name: 'SQ_CI_APP_STORE_CONNECT_KEY_ID',
            description: 'Identifier of key for App Store Connect API',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_store_connect_key_issuer_id,
            env_name: 'SQ_CI_APP_STORE_CONNECT_KEY_ISSUER_ID',
            description: 'Identifier of issuer of for App Store Connect API',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_store_connect_key_path,
            env_name: 'SQ_CI_APP_STORE_CONNECT_KEY_PATH',
            description: 'Path to file with App Store Connect API key',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_store_connect_session_duration,
            env_name: 'SQ_CI_APP_STORE_CONNECT_SESSION_DURATION',
            description: 'Duration of session in App Store Connect API',
            optional: true,
            type: Integer,
            default_value: 500
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
