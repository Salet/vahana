module Vahana
  class Redis
    attr_reader :client

    def class_name
      'redis'
    end
    
    def initialize
      @client = ::Redis.new
    end

    def seed
      @client.set('string', 'example string')
      @client.lpush('list', [4, 8, 8, 0])
      @client.sadd('set', [4, 8, 8, 0])
      @client.zadd("zset", [[4, "four"], [8, "eight"], [8, "eight"], [0, "zero"]])
      @client.hmset("hash", "name", "John", "age", "21")
    end

    def drop
      @client.flushall
    end

    def insert record
      raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      raise ArgumentError, 'Record id must be a string' unless record.id.is_a? String 
      raise ArgumentError, 'Record value must be a string' unless record.value.is_a? String 
      @client.set([record.namespace, record.id].join(':'), record.value)
    end

    def each
      return enum_for(:each) unless block_given?

      all_ids.each do |key|

        key_array = key.split(':')  
        if key_array.length > 1
          namespace = key_array.first
          id        = key_array[1..-1].join(':')
        else
          namespace = nil
          id        = key
        end

        case @client.type(key)
        when 'string'
          yield Vahana::SingleRecord.new(id, @client.get(key), namespace)
        when 'hash'
          yield Vahana::SingleRecord.new(id, @client.hgetall(key), namespace)
        when 'list'
          yield Vahana::SingleRecord.new(id, @client.lrange(key, 0, -1), namespace)
        when 'set'
          yield Vahana::SingleRecord.new(id, @client.smembers(key), namespace)
        when 'zset'
          yield Vahana::SingleRecord.new(id, @client.zrange(key, 0, -1, { withscores: true }).map { |v| Hash[['_id', 'score'].zip(v)] }, namespace)
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

    def all_ids
      @client.keys '*'
    end

    def record_for_mongo record
      record.namespace ||= 'redis'
      record.value = {value: record.value}
      return record
    end

    def record_for_cassandra record
      record.namespace ||= 'redis'
      record.value = {id: record.id, value: record.value}
      return record
    end

  end
end