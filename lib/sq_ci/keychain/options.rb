require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCi
  module Keychain
    class Options
      def self.options
        [
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
          )
        ]
      end
    end
  end
end
