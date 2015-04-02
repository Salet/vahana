module Vahana
  class Redis
    attr_reader :client
    
    def initialize
      @client = ::Redis.new
    end

    def class_name
      'redis'
    end

    def drop
      @client.flushall
    end

    def seed
      @client.set('string', 'example string')
      @client.lpush('list', [4, 8, 8, 0])
      @client.sadd('set', [4, 8, 8, 0])
      @client.zadd("zset", [[4, "four"], [8, "eight"], [8, "eight"], [0, "zero"]])
      @client.hmset("hash", "name", "John", "age", "21")
    end

    def all_ids
      @client.keys '*'
    end

    def insert record
      raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      raise ArgumentError, 'Record id must be a string' unless record.id.is_a? String 
      raise ArgumentError, 'Record value must be a string' unless record.value.is_a? String 
      @client.set(record.id, record.value)
    end

    def delete id
      raise ArgumentError, 'Argument id must be a string' unless id.is_a? String 
      @client.del(id)
    end

    def each
      return enum_for(:each) unless block_given?

      self.all_ids.each do |id|
        case @client.type(id)
        when 'string'
          yield Vahana::SingleRecord.new(id, @client.get(id))
        when 'hash'
          yield Vahana::SingleRecord.new(id, @client.hgetall(id))
        when 'list'
          yield Vahana::SingleRecord.new(id, @client.lrange(id, 0, -1))
        when 'set'
          yield Vahana::SingleRecord.new(id, @client.smembers(id))
        when 'zset'
          yield Vahana::SingleRecord.new(id, @client.zrange(id, 0, -1, { withscores: true }).map { |v| Hash[['_id', 'score'].zip(v)] })
        end
      end
    end

    def transfer_all_to client
      self.each do |record|
        decorated_record = self.send("record_for_#{client.class_name}".to_sym, record)
        client.insert(decorated_record)
      end
    end

    def record_for_mongo record
      record.namespace = 'redis'
      record.value = {value: record.value}
      return record
    end
  end
end

# Vahana::Redis.new.transfer_all_to Vahana::Mongo.new('db')