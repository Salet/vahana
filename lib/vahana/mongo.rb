module Vahana
  class Mongo
    attr_reader :client

    def initialize db = 'db'
      @client = ::Mongo::Client.new([ '127.0.0.1:27017' ], database: db)
    end

    def drop
      @client.database.drop
    end

    def seed
      raise NotImplementedError
    end

    def insert key, value, collection = 'test'
      @client[collection].insert_one({_id: key}.merge(value))
    end
  end
end