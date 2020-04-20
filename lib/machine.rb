class Machine

  attr_reader :alphabet
  def initialize
    @alphabet = ("a".."z").to_a << " "
  end

  def create_shifts(key, date)
    split_key(key).zip(date_to_offsets(date)).map { |key_offset| key_offset.reduce(:+) }
  end

  def split_key(key)
    key_array = []
    key.chars.each_cons(2){|key_chars| key_array << key_chars.join}
    key_array.map { |key_char| key_char.to_i }
  end

  def date_to_offsets(date)
    (date.to_i ** 2).to_s.chars.last(4).map { |char| char.to_i }
  end

  def split_message(message)
    message.chomp.chars.each_slice(4).to_a.map do |chars|
      chars.map { |char| char.downcase }
    end
  end

end
