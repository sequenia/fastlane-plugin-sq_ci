require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require_relative '../../../../sq_ci/s3/options'
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
        file_key = "#{File.basename(file_path, '.*')}#{File.extname(file_path)}"

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
          key: file_key
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
        ::SqCi::S3::Options.options
      end

      def self.return_type
        :string
      end

      def self.return_value
        'Link for uploaded file'
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
