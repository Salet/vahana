module Vahana
  module Cli
    class Application < Thor

      desc 'prepare', 'Drops data from all databases. Use with care!'
      def prepare
        Vahana::Redis.new.drop
        Vahana::Mongo.new.drop
        Vahana::Redis.new.drop
        Vahana::Redis.new.drop
      end

      desc 'seed TARGET', 'Seeds TARGET database with test data.'
      def seed(database)
        begin
          ['Vahana', database.capitalize].inject(Object) {|o,c| o.const_get c}.new.seed
        rescue NameError
          say "ERROR: Provided target is not supported. Compatible databases are: redis, mongo, cassandra, neo4j."
        end
      end

      desc 'migrate SOURCE TARGET', 'Copies all data from SOURCE to TARGET database.'
      def migrate(source, target)
        begin
          say "Migrating all data from #{source.capitalize} to #{target.capitalize}..."
          s = ['Vahana', source.capitalize].inject(Object) {|o,c| o.const_get c}.new
          t = ['Vahana', target.capitalize].inject(Object) {|o,c| o.const_get c}.new
          s.transfer_all_to(t)
          say 'Done!'
        rescue NoMethodError
          say "WARNING: This migration is not implemented yet."
        rescue NameError
          say "ERROR: Provided source or target is not supported. Compatible databases are: redis, mongo, cassandra, neo4j."
        end
      end

    end
  end
end