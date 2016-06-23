
module FilterAdder
  extend self

  def filter(pixels, header)
    scanline_length = 1 + ((header.ihdr.width * header.channel_count * header.ihdr.bit_depth) + 7) / 8

    filtered_lines = []
    index = 0

    # Substract one byte (filter type)
    scanline_length -= 1

    loop {
      filtered_lines << "\x00" + pixels[index, scanline_length]
      index += scanline_length

      break if filtered_lines.last.size < scanline_length
    }

    filtered_lines.join
  end
end
