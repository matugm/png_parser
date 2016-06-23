
module FilterRemover
  extend self

  def unfilter(image_data, header)
    # scanlines
    lines = divide_into_scanlines(image_data, header)

    last_line = []
    unfiltered_pixels = []

    # scanline loop
    lines.each do |line|
      filter_type = line[0]

      left = 0
      above_left = 0

      unfiltered_line = []

      # byte loop
      line[1..-1].each_char.with_index do |byte, idx|
        case filter_type
        when "\x00"
          unfiltered_line << byte
        when "\x01"
          unfiltered_line << [byte.bytes.first + left].pack("c")
        when "\x02"
          unfiltered_line << [byte.bytes.first + get_above(idx, last_line)].pack("c")
        when "\x03"
          unfiltered_line << [byte.bytes.first + ((get_above(idx, last_line) + left) >> 1)].pack("c")
        when "\x04"
          unfiltered_line << [byte.bytes.first + png_paeth_predictor(left, get_above(idx, last_line), get_above_left(idx, last_line))].pack("c")
        end

        # -3 -> pixel lenght
        left = unfiltered_line[-3].bytes.first if unfiltered_line.size >= 3

        # Extraneous 0xFF bytes...
      end

      last_line = unfiltered_line
      unfiltered_pixels << unfiltered_line
    end

    unfiltered_pixels = unfiltered_pixels.join
  end

  # Needs header info
  def divide_into_scanlines(data, header)
    scanline_length = 1 + ((header.ihdr.width * header.channel_count * header.ihdr.bit_depth) + 7) / 8

    lines = []
    index = 0

    loop {
      lines << data[index, scanline_length]
      index += scanline_length

      break if lines.last.size < scanline_length
    }

    # Delete empty string
    lines.delete_at(-1)

    lines
  end

  def get_above(idx, last_line)
    last_line.size == 0 ? 0 : last_line[idx].bytes.first
  end

  def get_above_left(idx, last_line)
    if (last_line.size == 0 || idx < 3)
      0
    else
      last_line[idx-3].bytes.first
    end
  end

  def png_paeth_predictor(a, b, c)
    p = (a + b - c)
    pa = (p - a).abs
    pb = (p - b).abs
    pc = (p - c).abs

    if ( pa <= pb ) && ( pa <= pc )
      return a
    elsif ( pb <= pc )
      return b
    else
      return c
    end
  end
end
