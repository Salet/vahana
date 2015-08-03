module Vahana
  module Cli
    class Neo4j < Thor

      def initialize(*args)
        super
        @source = Vahana::Neo4j.new
      end

      desc 'redis', 'Migrates data from Neo4j to Redis'
      def redis
        puts "WARNING: This migration is not implemented"
      end

      desc 'mongo', 'Migrates data from Neo4j to MongoDB'
      def mongo
        puts "WARNING: This migration is not implemented"
      end

      desc 'cassandra', 'Migrates data from Neo4j to Cassandra'
      def cassandra
        puts "WARNING: This migration is not implemented"
      end

      desc 'drop', 'Drops all data from selected database'
      def drop
        @source.drop
      end

      desc 'seed', 'Seeds selected database with test data'
      def seed
        @source.drop
        @source.seed
      end
    end
  end
end