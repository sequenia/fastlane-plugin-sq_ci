require 'fastlane/action'
require_relative '../helper/sq_ci_helper'
require 'net/http/post/multipart'

module Fastlane
  module Actions
    class SqCiSendTelegramMessageAction < Action
      def self.run(params)
        access_token = params[:telegram_access_token]
        chat_ids = params[:telegram_chat_ids]
        if access_token.nil? || access_token == "" || chat_ids.nil? || chat_ids == ""
          return
        end

        uri = URI.parse("https://api.telegram.org/bot#{access_token}/sendMessage")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        chat_ids.split(',').each do |chat_id|
          request = Net::HTTP::Post::Multipart.new(uri, {
            "chat_id" => chat_id,
            "text" => params[:message],
            "parse_mode" => params[:parse_mode]
          })

          http.request(request)
        end
      end

      def self.description
        'Send message via telegram'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :message,
            description: 'Message for send',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :telegram_access_token,
            env_name: 'SQ_CI_TELEGRAM_ACCESS_TOKEN',
            description: 'Access token for Telegram bot',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :telegram_chat_ids,
            env_name: 'SQ_CI_TELEGRAM_CHAT_IDS',
            description: 'Telegram\'s chat ids for send message',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :parse_mode,
            env_name: 'SQ_CI_TELEGRAM_PARSE_MODE',
            description: 'Telegram\'s parse mode',
            optional: true,
            type: String,
            default_value: "Markdown"
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
