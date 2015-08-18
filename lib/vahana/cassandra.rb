module Vahana
  class Cassandra
    attr_reader :client

    def class_name
      'cassandra'
    end

    def initialize keyspace = 'app'
      @client = ::Cassandra.cluster.connect(keyspace)   
    end   

    def seed
      @client.execute("create table #{@client.keyspace}.users (id uuid primary key, first_name text, last_name text)")
      @client.execute("insert into #{@client.keyspace}.users (id, first_name, last_name) values (uuid(), 'John', 'Snow')")
      @client.execute("insert into #{@client.keyspace}.users (id, first_name, last_name) values (uuid(), 'Stannis', 'Baratheon')")
      @client.execute("insert into #{@client.keyspace}.users (id, first_name, last_name) values (uuid(), 'Jaime', 'Lannister')")

      @client.execute("create table #{@client.keyspace}.cities (id uuid primary key, name text)")
      @client.execute("insert into #{@client.keyspace}.cities (id, name) values (uuid(), 'Winterfell')")
      @client.execute("insert into #{@client.keyspace}.cities (id, name) values (uuid(), 'Kings Landing')")
      @client.execute("insert into #{@client.keyspace}.cities (id, name) values (uuid(), 'Braavos')")
    end 

    def drop
      all_tables.each do |table|
        @client.execute("drop table #{table}")
      end
    end    

    def insert record
      raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      raise ArgumentError, 'Record id must be a string' unless record.id.is_a? String 
      raise ArgumentError, 'Record value must be a hash' unless record.value.is_a? Hash 
      raise ArgumentError, 'Record namespace must be a string' unless record.namespace.is_a? String 
      @client[record.namespace].insert_one({_id: record.id}.merge(record.value))
    end

    def each
      return enum_for(:each) unless block_given?

      all_tables.each do |table|
        @client.execute("select * from #{@client.keyspace}.#{table}").rows.each do |row|
          yield Vahana::SingleRecord.new(row.delete(row.first[0]).to_s, row, table)
        end
      end
    end

    def transfer_all_to client
      self.each do |record|
        decorated_record = self.send("record_for_#{client.class_name}".to_sym, record)
        client.insert(decorated_record)
      end
    end

    private    

    def all_tables
      result = @client.execute("SELECT columnfamily_name FROM system.schema_columnfamilies WHERE keyspace_name = '#{@client.keyspace}' ")
      a = []
      result.rows.each do |row|
        a << row["columnfamily_name"]
      end
      return a
    end

    def record_for_mongo record
      return record
    end

  end
end