class MigrationUtils
  # @param session [Cassandra#Cluster]
  # @return [Boolean]
  def self.keyspace_exist?(session:)
    query = <<~SQL
      select keyspace_name from system_schema.keyspaces WHERE keyspace_name = ?
    SQL

    session.execute_async(query, arguments: [KEYSPACE_NAME]).join.rows.size.zero?
  end

  # @param session [Cassandra#Cluster]
  # @return [Boolean]
  def self.table_exist?(session:)
    query = <<~SQL
      select keyspace_name, table_name from system_schema.tables WHERE keyspace_name = ? AND table_name = ?
    SQL

    session.execute_async(query, arguments: [KEYSPACE_NAME, TABLE_NAME]).join.rows.size.zero?
  end

  # @param session [Cassandra#Cluster]
  # @return [void]
  def self.create_keyspace(session:)
    query = <<~SQL
      CREATE KEYSPACE #{KEYSPACE_NAME}
      WITH replication = {
        'class': 'NetworkTopologyStrategy',
        'replication_factor': '3'
      }
      AND durable_writes = true
    SQL

    session.execute_async(query).join
  end

  # @param session [Cassandra#Cluster]
  # @return [void]
  def self.create_table(session:)
    query = <<~SQL
      CREATE TABLE #{KEYSPACE_NAME}.#{TABLE_NAME} (
        id uuid,
        title text,
        album text,
        artist text,
        created_at timestamp,
        PRIMARY KEY (id, created_at)
      );
    SQL

    session.execute_async(query).join
  end
end
