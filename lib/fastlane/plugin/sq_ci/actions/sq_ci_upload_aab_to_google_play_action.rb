require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require_relative '../../../../sq_ci/google_play/options'
require_relative '../../../../sq_ci/android_app/options'
require_relative '../../../../sq_ci/shared/options'

module Fastlane
  module Actions
    class SqCiUploadAabToGooglePlayAction < Action
      def self.run(params)
        puts(params)

        google_play_client = Supply::Client.make_from_config(
          params: {
            json_key: params[:json_key_file],
            timeout: params[:timeout]
          }
        )
        puts(google_play_client)

        # build_type = params[:build_type]
        # flavor = params[:flavor]
        # project_folder = params[:project_folder]

        # other_action.gradle(
        #   task: 'assemble',
        #   flavor: flavor,
        #   build_type: build_type,
        #   project_dir: project_folder
        # )

        # if params[:should_upload_apk]
        #   other_action.sq_ci_upload_file_to_s3(
        #     file_path: lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]
        #   )
        # end
      end

      def self.description
        'Upload aab file to the Google Play'
      end

      def self.details
        ''
      end

      def self.available_options
        ::SqCi::GooglePlay::Options.options +
          ::SqCi::AndroidApp::Options.options +
          ::SqCi::Shared::Options.options
      end

      def self.return_type
        :string
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
