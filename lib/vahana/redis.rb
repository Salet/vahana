module Vahana
  class Redis
    attr_reader :client
    
    def initialize
      @client = ::Redis.new
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

    def insert key, value
      @client.set(key, value)
    end
  end
end