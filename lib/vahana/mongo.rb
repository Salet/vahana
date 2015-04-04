module Vahana
  class Mongo
    attr_reader :client

    def class_name
      'mongo'
    end

    def initialize db = 'db'
      ::Mongo::Logger.logger.level = ::Logger::INFO
      @client = ::Mongo::Client.new([ '127.0.0.1:27017' ], database: db)      
    end   

    def seed
      raise NotImplementedError
    end 

    def drop
      @client.database.drop
    end    

    def insert record
      raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      raise ArgumentError, 'Record id is must be a string' unless record.id.is_a? String 
      raise ArgumentError, 'Record value must be a hash' unless record.value.is_a? Hash 
      raise ArgumentError, 'Record namespace is must be a string' unless record.namespace.is_a? String 
      @client[record.namespace].insert_one({_id: record.id}.merge(record.value))
    end

    def each
      return enum_for(:each) unless block_given?

      all_collections.each do |collection|
        @client[collection].find.each do |document|
          hash = document.to_h
          value_hash = hash.reject{|k| k == '_id'}
          yield Vahana::SingleRecord.new("#{collection}.#{hash['_id'].to_s}", value_hash)
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

    def all_collections
      collections = @client.database.collection_names
    end

    def record_for_redis record
      record.value = record.value.to_json
      return record
    end

  end
end