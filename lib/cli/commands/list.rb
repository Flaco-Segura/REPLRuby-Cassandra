# frozen_string_literal: true

require 'dry/cli'

module Cli
  module Commands
    class List < Dry::CLI::Command
      desc 'This command shows all the created songs'
    
      def initialize
        super
        @repo = Application['database.connection']
      end

      def call
        query = <<~SQL
          SELECT * FROM #{KEYSPACE_NAME}.#{TABLE_NAME};
        SQL

        @repo.execute_async(query).join.rows.each do |song|
          puts <<~MSG
            ID: #{song['id']} | Song Name: #{song['title']} | Album: #{song['album']} | Artist: #{song['artist']} | Created At: #{song['created_at']}
          MSG
        end
      end
    end
  end
end
