# frozen_string_literal: true

require 'dry/cli'

module Cli
  module Commands
    class Update < Dry::CLI::Command
      desc 'This command will prompt for a song to be updated and use the argument information to updated it'

      argument :title, type: :string, required: true, desc: 'The title of the song'
      argument :album, type: :string, required: true, desc: 'The name of the album'
      argument :artist, type: :string, required: true, desc: 'The name of the artist'
      
      def initialize
        super
        @repo = Application['database.connection']
      end

      def call(title:, album:, artist:)
        songs = @repo.execute_async("SELECT * FROM #{KEYSPACE_NAME}.#{TABLE_NAME}").join.rows

        song_to_update_index = select_song_to_update(songs: songs)

        query = <<~SQL
          UPDATE #{KEYSPACE_NAME}.#{TABLE_NAME} SET title = ?, artist = ?, album = ? WHERE id = ? AND created_at = ?
        SQL

        song_to_update = songs.to_a[song_to_update_index]

        @repo.execute_async(query, arguments: [title, artist, album, song_to_update['id'], song_to_update['created_at']]).join
      end

      private

      # @param songs [Array<Hash>]
      def select_song_to_update(songs:)
        songs.each_with_index do |song, index|
          puts <<~DESC
            #{index + 1}) Song: #{song['title']} | Album: #{song['album']} | Artist: #{song['artist']} | Created At: #{song['created_at']}
          DESC
        end

        print 'Select a song to be updated: '
        $stdin.gets.chomp.to_i - 1
      end
    end
  end
end
