require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCi
  module IosApp
    class Options
      def self.options
        [
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
            key: :main_target,
            description: 'Name of main target',
            env_name: 'SQ_CI_MAIN_TARGET',
            optional: true,
            type: String
          )
        ]
      end
    end
  end
end
