module Vahana
  module Cli
    class Application < Thor

      @@databases = %w(redis mongo cassandra neo4j)

      map %w[--version -v] => :__print_version
      desc "-v, --version", "Check gem version"
      def __print_version
        puts "vahana #{Vahana::VERSION}"
      end

      desc 'list', 'Shows compatible database names'
      def list
        puts "Compatible databases are:"
        puts @@databases
      end

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
          #puts $!
        rescue NameError
          say "ERROR: Provided source or target is not supported."
          list
        end
      end

    end
  end
end