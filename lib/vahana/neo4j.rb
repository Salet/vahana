module Vahana
  class Neo4j
    attr_reader :client

    def class_name
      'neo4j'
    end

    def initialize user = 'neo4j', password = 'root'
      @client = ::Neo4j::Session.open(:server_db, 'http://127.0.0.1:7474', basic_auth: { username: user, password: password})  
    end   

    def seed
      # CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})
      # CREATE (Hannibal:Movie {title:'Hannibal', released:2001})
      # CREATE (RedDragon:Movie {title:'Red Dragon', released:2002})
      # CREATE (Keanu:Person {name:'Keanu Reeves', born:1964})
      # CREATE (Carrie:Person {name:'Carrie-Anne Moss', born:1967})
      # CREATE (Hugo:Person {name:'Hugo Weaving', born:1960})
      # CREATE (AndyW:Person {name:'Andy Wachowski', born:1967})
      # CREATE
      #   (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrix),
      #   (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrix),
      #   (AndyW)-[:DIRECTED]->(TheMatrix),
      #   (Hannibal)-[:IS_PREQUEL_TO]->(RedDragon)
    end 

    def drop
      @client.query.match(:n).optional_match('(n)-[r]-()').delete(:n, :r).exec
    end    

    def insert record
      # raise ArgumentError, 'Record must be a SingleRecord' unless record.is_a? SingleRecord 
      # raise ArgumentError, 'Record id is must be a string' unless record.id.is_a? String 
      # raise ArgumentError, 'Record value must be a hash' unless record.value.is_a? Hash 
      # raise ArgumentError, 'Record namespace is must be a string' unless record.namespace.is_a? String 
      # @client[record.namespace].insert_one({_id: record.id}.merge(record.value))
    end

    def each
      return enum_for(:each) unless block_given?

      all_nodes.each do |struct|
        node = struct.n

        # TODO: do ciała dodać n.rels (iteracja, wyciągnięcie wartości)

        # ...
        yield Vahana::SingleRecord.new(n.neo_id, n.props, n.labels.first.to_s)
      end

    end

    def transfer_all_to client
      self.each do |record|
        decorated_record = self.send("record_for_#{client.class_name}".to_sym, record)
        client.insert(decorated_record)
      end
    end


    private

    def all_nodes
      @client.query.match(:n).return(:n)
      # @client.query.match('(n)-[r]-()').return(:n, :r).response.data
    end

    def record_for_redis record
      # record.value = record.value.to_json
      # return record
    end

  end
end