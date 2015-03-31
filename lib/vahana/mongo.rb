module Vahana
  class Mongo

    def initialize db = 'db'
      @client = ::Mongo::MongoClient.new.db(db)
    end

  end
end