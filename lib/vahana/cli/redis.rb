module Vahana
  module Cli
    class Redis < Thor

      def initialize(*args)
        super
        @source = Vahana::Redis.new
      end

      desc 'mongo', 'Migrates data from Redis to MongoDB'
      def mongo
        say "Migrating..."
        @source.transfer_all_to(Vahana::Mongo.new)
        say "Done!"
      end

      desc 'cassandra', 'Migrates data from Redis to Cassandra'
      def cassandra
        puts "WARNING: This migration is not implemented"
      end

      desc 'neo4j', 'Migrates data from Redis to Neo4j'
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