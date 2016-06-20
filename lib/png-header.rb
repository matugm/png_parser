
class PNG_Image < BinData::Record
  endian :big

  array :signature, :type => :uint8, initial_length: 8

  struct :ihdr do
    uint32 :chunk_length
    uint32 :chunk_type

    uint32 :width
    uint32 :height

    uint8  :bit_depth
    uint8  :color_type
    uint8  :compression_method
    uint8  :filter_method
    uint8  :interlace

    uint32 :crc
  end

  COLOR_TYPES = {
    0 => [:grey_scale],
    2 => [:R, :G, :B],
    3 => [:palette_index],
    4 => [:grey_scale, :alpha],
    6 => [:R, :G, :B, :alpha]
  }

  def channel_count
    3
  end

  def pretty_print(pp)
    ihdr.each_pair do |k, v|
      pp.text "#{k}:".ljust(20)
      pp.text "#{v}\n"
    end
  end
end
