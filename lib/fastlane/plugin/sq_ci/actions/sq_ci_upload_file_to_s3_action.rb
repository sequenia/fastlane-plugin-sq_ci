require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require 'aws-sdk-core'

module Fastlane
  module Actions
    class SqCiUploadFileToS3Action < Action
      def self.run(params)
        access_key = params[:s3_access_key_id]
        key_secret = params[:s3_secret_access_key]
        bucket_name = params[:s3_bucket_name]
        region_name = params[:s3_region_name]
        endpoint = params[:s3_endpoint]

        file_path = params[:file_path]
        file_expire_at = Time.at(Time.now.to_i + params[:file_expire_at])
        file_key = "#{File.basename(file_path, '.*')}-#{Time.now.to_i}#{File.extname(file_path)}"

        credentials = Aws::Credentials.new(access_key, key_secret)
        s3_client = Aws::S3::Client.new(
          region: region_name,
          credentials: credentials,
          endpoint: endpoint
        )

        # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#put_object-instance_method
        s3_client.put_object(
          acl: 'public-read',
          body: File.open(file_path),
          bucket: bucket_name,
          key: file_key,
          expires: file_expire_at
        )

        uploaded_object = Aws::S3::Object.new(bucket_name, file_key, client: s3_client)
        public_url = uploaded_object.public_url

        return public_url
      end

      def self.description
        'Upload file to S3-compatible storage'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :file_path,
            description: 'Path to uploaded file',
            optional: false,
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
          ),
          FastlaneCore::ConfigItem.new(
            key: :file_expire_at,
            description: 'Expire at for uploaded to S3 storage files',
            optional: true,
            type: Integer,
            default_value: 7_776_000
          )
        ]
      end

      def self.return_type
        :string
      end

      def self.return_value
        'Link for download file'
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
