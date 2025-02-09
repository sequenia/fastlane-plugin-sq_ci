require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCi
  module S3
    class Options
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :file_path,
            description: 'Path to file for upload',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :relative_path,
            description: 'Folder on s3 storage',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :s3_access_key_id,
            env_name: 'SQ_CI_S3_ACCESS_KEY_ID',
            description: 'Identifier for S3 access key',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :s3_secret_access_key,
            env_name: 'SQ_CI_S3_SECRET_ACCESS_KEY',
            description: 'Secret for S3 access key',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :s3_region_name,
            env_name: 'SQ_CI_S3_REGION_NAME',
            description: 'Region name of S3 storage',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :s3_bucket_name,
            env_name: 'SQ_CI_S3_BUCKET_NAME',
            description: 'S3\'s bucket name',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :s3_endpoint,
            env_name: 'SQ_CI_S3_ENDPOINT',
            description: 'Endpoint for S3 storage',
            optional: false,
            type: String
          )
        ]
      end
    end
  end
end
