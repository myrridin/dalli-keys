class DalliKey
  attr_accessor :key, :size, :expiration

  def initialize(key, size, expiration)
    @key = key
    @size = size
    @expiration = expiration
  end
end