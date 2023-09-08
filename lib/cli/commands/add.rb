# frozen_string_literal: true

require 'dry/cli'

module Cli
  module Commands
    class Add < Dry::CLI::Command
      desc 'This command add a new song to the playlist'

      argument :title, type: :string, required: true, desc: 'The title of the song'
      argument :album, type: :string, required: true, desc: 'The name of the album'
      argument :artist, type: :string, required: true, desc: 'The name of the artist'

      def initialize
        super
        @repo = Application['database.connection']
      end

      def call(title:, album:, artist:)
        query = <<~SQL
          INSERT INTO #{KEYSPACE_NAME}.#{TABLE_NAME} (id,title,artist,album,created_at) VALUES (now(),?,?,?,?);
        SQL

        @repo.execute_async(query, arguments: [title, artist, album, Time.now]).join

        puts "Song '#{title}' from artist '#{artist}' Added!"
      end
    end
  end
end
