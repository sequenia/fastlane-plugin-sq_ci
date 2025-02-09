require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require_relative '../../../../sq_ci/google_play/options'
require_relative '../../../../sq_ci/android_app/options'
require_relative '../../../../sq_ci/shared/options'

module Fastlane
  module Actions
    class SqCiGetLastVersionCodeFromGooglePlayAction < Action
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
        result = google_play_client.aab_version_codes
        google_play_client.abort_current_edit
        return result.last
      end

      def self.description
        'Fetch the last version code from Google Play\'s app bundle explorer'
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
        :int
      end

      def self.return_value
        'Number of the last version uploaded to Google Play'
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
