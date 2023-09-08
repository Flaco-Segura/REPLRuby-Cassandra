# frozen_string_literal: true

Application.register_provider(:database) do
  prepare do
    require 'cassandra'
    require_relative '../../lib/migration_utils'
    require_relative '../constants'
  end

  start do
    cluster = Cassandra.cluster(
      username: ENV.fetch('DB_USER', nil),
      password: ENV.fetch('DB_PASSWORD', nil),
      hosts: ENV.fetch('DB_HOSTS', nil).split(',')
    )

    connection = cluster.connect

    MigrationUtils.create_keyspace(session: connection) if MigrationUtils.keyspace_exist?(session: connection)
    MigrationUtils.create_table(session: connection) if MigrationUtils.table_exist?(session: connection)


    connection = cluster.connect(KEYSPACE_NAME)

    register('database.connection', connection)
  end
end
