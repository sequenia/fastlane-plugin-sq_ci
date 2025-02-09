require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require_relative '../../../../sq_ci/google_play/options'
require_relative '../../../../sq_ci/android_app/options'
require_relative '../../../../sq_ci/shared/options'

module Fastlane
  module Actions
    class SqCiUploadAabToGooglePlayAction < Action
      def self.run(params)
        google_play_client = Supply::Client.make_from_config(
          params: {
            json_key: params[:json_key_file],
            timeout: params[:timeout]
          }
        )

        Supply.config = params

        google_play_client.begin_edit(
          package_name: params[:package_name]
        )

        google_play_client.upload_bundle(
          params[:aab_path]
        )
        google_play_client.commit_current_edit!
      end

      def self.description
        'Upload aab file to the Google Play'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :aab_path,
            description: "Path to the aab file",
            optional: false,
            type: String
          )
        ] +
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
