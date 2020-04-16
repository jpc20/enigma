class Enigma

  def encrypt(message, key, date)
  end

  def split_key(key)
    key_array = []
    key.chars.each_cons(2){|chars| key_array << chars.join}
    key_array
  end

  def date_to_offsets(date)
    (date.to_i ** 2).to_s.chars.last(4)
  end

end
