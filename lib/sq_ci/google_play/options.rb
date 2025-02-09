require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCi
  module GooglePlay
    class Options
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :json_key_file,
            env_name: "SQ_CI_JSON_KEY_FILE",
            optional: true,
            description: "The path to a file containing service account JSON, used to authenticate with Google",
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:json_key_file),
            default_value_dynamic: true,
            verify_block: proc do |value|
              UI.user_error!("Could not find service account json file at path '#{File.expand_path(value)}'") unless File.exist?(File.expand_path(value))
              UI.user_error!("'#{value}' doesn't seem to be a JSON file") unless FastlaneCore::Helper.json_file?(File.expand_path(value))
            end
          )
        ]
      end
    end
  end
end
