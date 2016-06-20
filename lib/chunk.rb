
class Chunk < BinData::Record
  endian :big

  uint32 :chunk_length
  uint32 :chunk_type

  string :data, :read_length => :chunk_length
  uint32 :crc

  def pretty_print(pp)
    decoded_type = Array(chunk_type.to_i).pack("i*").reverse

    pp.group(1) {
      pp.text "Type: #{chunk_type} (#{decoded_type})"
      pp.text "".ljust(5)
      pp.text "Length: #{chunk_length}"
    }
  end
end
