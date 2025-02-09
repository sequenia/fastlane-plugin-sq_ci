require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCi
  module AndroidApp
    class Options
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :package_name,
            env_name: "SQ_CI_PACKAGE_NAME",
            description: "The package name of the Android application to use",
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:package_name),
            default_value_dynamic: true
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
    end
  end
end
