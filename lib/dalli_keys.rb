require_relative 'dalli_keys/dalli_key'

module DalliKeys
  VERSION = '0.0.1'

  def self.version
    VERSION
  end

  def self.get_keys_on_host(host = 'localhost', port = 11211)
    require 'date'
    require 'net/telnet'

    telnet = Net::Telnet.new('Host' => host, 'Port' => port, 'Prompt' => /^END/)

    uptime, current_time = get_stats(telnet)

    items = get_slab_ids(telnet).map do |slab_id|
      telnet.cmd("stats cachedump #{slab_id} 0").split("\n").select { |line| line =~ /^ITEM/ }
    end

    items.flatten.map do |item_line|
      match_data = item_line.match(/^ITEM\s(.*?)\s\[(\d+)\sb;\s(\d+)\ss\]/)
      if current_time - uptime == match_data[3].to_i
        expiration = nil
      else
        expiration = DateTime.strptime(match_data[3], '%s')
      end
      DalliKey.new(match_data[1], match_data[2].to_i, expiration)
    end
  end

  private

  def self.get_slab_ids(telnet)
    slab_lines = telnet.cmd('stats slabs').split("\n").select { |l| l =~ /^STAT\s(\d+)/ }
    slab_lines.map { |l| l.match(/^STAT\s(\d+):/)[1] }.map(&:to_i).uniq
  end

  def self.get_stats(telnet)
    stat_lines = telnet.cmd('stats').split("\n")
    uptime = stat_lines.detect { |l| l.include? 'STAT uptime' }.sub('STAT uptime ', '').to_i
    current_time = stat_lines.detect { |l| l.include? 'STAT time' }.sub('STAT time ', '').to_i
    return uptime, current_time
  end
end

# Monkey patch for Dalli::Client
module Dalli
  class Client
    def keys
      keys = @servers.map do |server|
        host, port = server.split(':')
        DalliKeys.get_keys_on_host(host, port)
      end
      keys.flatten
    end
  end
end