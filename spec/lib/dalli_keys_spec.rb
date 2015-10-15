RSpec.describe DalliKeys do
  let!(:dalli) { Dalli::Client.new('localhost:11211') }

  before(:each) { dalli.flush_all }

  describe '.get_keys_on_host' do
    it 'returns a list of keys' do
      dalli.set('abc', 123, 0)
      dalli.set('test', 'test', 0)
      keys = DalliKeys.get_keys_on_host('localhost', 11211)
      expect(keys.count).to eq 2
    end

    it 'properly parses expirations' do
      dalli.set('test', 'test')
      dalli.set('expiring_key', 'junk data', 3600)
      keys = DalliKeys.get_keys_on_host('localhost', 11211)
      expirations = keys.map(&:expiration)
      expect(expirations).to include(nil, an_instance_of(DateTime))
    end
  end

  describe 'Dalli::Client monkey patch' do
    it 'properly adds a #keys method to Dalli::Client' do
      dalli.set('abc', 123, 0)
      dalli.set('test', 'test', 0)
      keys = dalli.keys
      expect(keys.count).to eq 2
    end
  end
end