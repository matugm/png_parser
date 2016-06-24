
class ImageGenerator
  def self.generate(header, data)
    output = File.open("#{__dir__}/../img/output.png", "w")

    ## Write PNG signature + IHDR ##

    header.write(output)

    ## Write data chunk ##

    Chunk.new.tap do |ch|
      ch.data = data
      ch.crc  = Zlib.crc32("IDAT" + ch.data)

      ch.chunk_length = ch.data.size
      ch.chunk_type   = 1229209940

      ch.write(output)
    end

    ## Write IEND chunk ##

    Chunk.new.tap do |ch|
      ch.data = ""
      ch.crc  = Zlib.crc32("IEND")

      ch.chunk_length = 0
      ch.chunk_type   = 1229278788

      ch.write(output)
    end
  end
end
