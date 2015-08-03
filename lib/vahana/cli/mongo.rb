module Vahana
  module Cli
    class Mongo < Thor

      def initialize(*args)
        super
        @source = Vahana::Mongo.new
      end

      desc 'redis', 'Migrates data from MongoDB to Redis'
      def redis
        puts "WARNING: This migration is not implemented"
      end

      desc 'cassandra', 'Migrates data from MongoDB to Cassandra'
      def cassandra
        puts "WARNING: This migration is not implemented"
      end

      desc 'neo4j', 'Migrates data from MongoDB to Neo4j'
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