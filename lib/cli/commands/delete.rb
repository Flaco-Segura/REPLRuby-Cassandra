# frozen_string_literal: true

require 'dry/cli'

module Cli
  module Commands
    class Delete < Dry::CLI::Command
      desc 'This command will prompt for a song to be deleted and then delete it'

      def initialize
        super
        @repo = Application['database.connection']
      end

      def call
        songs = @repo.execute_async("SELECT * FROM #{KEYSPACE_NAME}.#{TABLE_NAME}").join.rows

        song_to_delete_index = select_song_to_delete(songs: songs)

        query = <<~SQL
          DELETE FROM #{KEYSPACE_NAME}.#{TABLE_NAME} WHERE id = ?
        SQL

        song_to_delete = songs.to_a[song_to_delete_index]

        @repo.execute_async(query, arguments: [song_to_delete['id']]).join
      end

      private

      # @param songs [Array<Hash>]
      def select_song_to_delete(songs:)
        songs.each_with_index do |song, index|
          puts <<~DESC
            #{index + 1})  Song: #{song['title']} | Album: #{song['album']} | Artist: #{song['artist']} | Created At: #{song['created_at']}
          DESC
        end

        print 'Select a song to be deleted: '
        $stdin.gets.chomp.to_i - 1
      end
    end
  end
end
