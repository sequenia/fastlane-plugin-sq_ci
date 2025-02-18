require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiPrepareAppStoreConnectApiAction < Action
      def self.run(params)
        other_action.app_store_connect_api_key(
          key_id: params[:app_store_connect_key_id],
          issuer_id: params[:app_store_connect_key_issuer_id],
          key_filepath: params[:app_store_connect_key_path],
          in_house: false,
          duration: params[:app_store_connect_session_duration]
        )
      end

      def self.description
        'Prepare API Key for App Store Connect API'
      end

      def self.details
        ''
      end

      def self.available_options
        [
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
