require 'fastlane/action'
require_relative '../helper/sq_ci_helper'

module Fastlane
  module Actions
    class SqCiAddVersionTagAction < Action
      def self.run(params)
        app_version_string = other_action.sq_ci_get_app_version_string(
          target: params[:main_target]
        )

        other_action.git_pull

        other_action.add_git_tag(
          tag: "#{params[:tags_folder]}/#{app_version_string}"
        )

        other_action.push_to_git_remote(
          tags: true
        )
      end

      def self.description
        'Add version tag into git-repo'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :tags_folder,
            description: 'Name of folder of tag in repo',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :main_target,
            description: 'Name of main target',
            env_name: 'SQ_CI_MAIN_TARGET',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: 'SQ_CI_PROJECT_PATH',
            description: 'Path to project',
            optional: false,
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
