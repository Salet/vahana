module Vahana
  module Cli
    class Application < Thor

      desc 'hello NAME', 'Display greeting with given NAME'
      def hello(name)
        puts "Hello #{name}"
      end

      desc 'redis TARGET', 'Migrate data from Redis to TARGET database'
      subcommand 'redis', Vahana::Cli::Redis

      desc 'mongo TARGET', 'Migrate data from MongoDB to TARGET database'
      subcommand 'mongo', Vahana::Cli::Mongo

      desc 'neo4j TARGET', 'Migrate data from Neo4j to TARGET database'
      subcommand 'neo4j', Vahana::Cli::Neo4j

      desc 'cassandra TARGET', 'Migrate data from Cassandra to TARGET database'
      subcommand 'cassandra', Vahana::Cli::Cassandra
    end
  end
end