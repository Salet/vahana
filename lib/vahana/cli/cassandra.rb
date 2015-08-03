module Vahana
  module Cli
    class Cassandra < Thor

      def initialize(*args)
        super
        @source = Vahana::Cassandra.new
      end

      desc 'redis', 'Migrates data from Cassandra to Redis'
      def redis
        puts "WARNING: This migration is not implemented"
      end

      desc 'mongo', 'Migrates data from Cassandra to MongoDB'
      def mongo
        puts "WARNING: This migration is not implemented"
      end

      desc 'neo4j', 'Migrates data from Cassandra to Neo4j'
      def neo4j
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