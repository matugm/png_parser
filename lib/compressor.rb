require 'zlib'

class Compressor
  def self.inflate(chunks)
    data = chunks.select { |ch| ch.chunk_type == 1229209940 }.map(&:data).join
    Zlib::Inflate.inflate(data)
  end
end
