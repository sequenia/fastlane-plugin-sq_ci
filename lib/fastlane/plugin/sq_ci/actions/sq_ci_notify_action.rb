require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiNotifyAction < Action
      def self.run(params)
        links_message = params[:links]
                        .select { |link| !link[:url].nil? }
                        .map { |link| "#{link[:name] || 'Ссылка'}: #{link[:url]}" }
                        .join("\n\n")

        other_action.sq_ci_send_telegram_message(
          message: "#{message}\n\n#{links_message}"
        )
      end

      def self.description
        'Send message into a messengers'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :message,
            description: 'Message to send',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :links,
            description: 'Links to the end of message',
            optional: true,
            type: Array
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
