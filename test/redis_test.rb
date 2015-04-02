require "test_helper"

class RedisTest < Minitest::Test

  def setup
    @client = Vahana::Redis.new
  end

  def test_method_existance   
    assert_respond_to @client, :drop
    assert_respond_to @client, :all_ids
    assert_respond_to @client, :seed
    assert_respond_to @client, :insert
    assert_respond_to @client, :delete
  end

  def test_insert
    assert_equal @client.insert(Vahana::SingleRecord.new('test', 'test')), "OK"
    assert_raises(ArgumentError) { @client.insert(Vahana::SingleRecord.new([], 'test')) }
    assert_raises(ArgumentError) { @client.insert(Vahana::SingleRecord.new('test', [])) }
    assert_raises(ArgumentError) { @client.insert('test', 'key') }
  end

  def test_delete
    @client.insert(Vahana::SingleRecord.new('test', 'test'))
    assert_equal @client.delete('test'), 1
    assert_raises(ArgumentError) { @client.delete([]) }
  end

  def test_drop
    @client.drop
    assert_empty @client.all_ids
  end

  def test_seed
    @client.seed
    refute_empty @client.all_ids
  end

end