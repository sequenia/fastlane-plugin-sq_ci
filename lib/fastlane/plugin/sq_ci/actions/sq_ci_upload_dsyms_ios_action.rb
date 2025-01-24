require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiUploadDsymsIosAction < Action
      def self.run(params)
        firebase_config_file = params[:firebase_config_file]
        upload_dsyms_binary_path = params[:upload_dsyms_binary_path]

        firebase_config_file_exist = !firebase_config_file.nil? && firebase_config_file != ''
        upload_dsyms_binary_path_exist = !upload_dsyms_binary_path.nil? && upload_dsyms_binary_path != ''

        if upload_dsyms_binary_path_exist && firebase_config_file_exist
          other_action.upload_symbols_to_crashlytics(
            gsp_path: firebase_config_file,
            binary_path: upload_dsyms_binary_path
          )
        end
      end

      def self.description
        'Upload dsyms of iOS app'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :firebase_config_file,
            description: 'Path to firebase config file',
            env_name: SQ_CI_FIREBASE_CONFIG_FILE,
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :upload_dsyms_binary_path,
            description: 'Path to upload-dsyms binary',
            env_name: SQ_CI_UPLOAD_DSYMS_BINARY_PATH,
            optional: true,
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
