module Vahana
  class Mongo
    attr_reader :client

    def initialize db = 'db'
      @client = ::Mongo::Client.new([ '127.0.0.1:27017' ], database: db)
    end

    def class_name
      'mongo'
    end

    def drop
      @client.database.drop
    end

    def seed
      raise NotImplementedError
    end

    def all_ids
      raise NotImplementedError
    end

    def insert record
      raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      raise ArgumentError, 'Record id is must be a string' unless record.id.is_a? String 
      raise ArgumentError, 'Record value must be a hash' unless record.value.is_a? Hash 
      raise ArgumentError, 'Record namespace is must be a string' unless record.namespace.is_a? String 
      @client[record.namespace].insert_one({_id: record.id}.merge(record.value))
    end

    def delete id
      raise NotImplementedError
    end

    def each
      raise NotImplementedError
    end
  end
end