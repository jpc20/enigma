require_relative "machine"

class Decryptor < Machine

  def decrypt(encrypted_message, key, date = todays_date)
    {
      decryption: decrypt_message(encrypted_message, key, date),
      key: key,
      date: date
    }
  end

  def decrypt_message(encrypted_message, key, date)
    decrypted = ""
    shifts = create_shifts(key, date)
    split_message(encrypted_message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        decrypted.concat(decrypt_character(char, shift_value))
      end
    end
    decrypted
  end

  def crack(encrypted_message, date = todays_date)
    {
      decryption: crack_message(encrypted_message, date),
      key: find_key(encrypted_message, date),
      date: date
    }
  end

  def crack_message(encrypted_message, date)
    cracked = ""
    shifts = find_shifts(encrypted_message, date)
    split_message(encrypted_message).each do |encrypted_chars|
      encrypted_chars.zip(shifts).each do |encrypted_char, shift_value|
        cracked.concat(decrypt_character(encrypted_char, shift_value))
      end
    end
    cracked
  end

  def decrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) - shift) % 27
    @alphabet[new_index]
  end

  def find_shifts(encrypted_message, date)
    split_encrypted = split_message(encrypted_message)
    last_chars_length = split_encrypted.last.length
    end_array = [" ", "e", "n", "d"]
    if last_chars_length == 4
      shifts_for_multiple_of_4(split_encrypted, end_array)
    elsif last_chars_length < 4
      shifts_for_less_than_4_chars(split_encrypted, end_array, last_chars_length)
    end
  end

  def shifts_for_multiple_of_4(split_message, end_array)
    split_message.last.zip(end_array).map do |encrypted_char, end_char|
      shift_amount(encrypted_char, end_char)
    end
  end

  def shifts_for_less_than_4_chars(split_message, end_array, last_chars_length)
    shifts = split_message.last.zip(end_array.last(last_chars_length)).map do |encrypted_char, end_char|
      shift_amount(encrypted_char, end_char)
    end
    shifts << split_message[-2].last(4 - last_chars_length).each_with_index.map do |encrypted_char, index|
      shift_amount(encrypted_char, end_array[index])
    end
    shifts.flatten
  end

  def shift_amount(encrypted_char, end_char)
    (@alphabet.find_index(encrypted_char) - @alphabet.find_index(end_char)) % 27
  end

  def find_key(encrypted_message, date)
    combine_keys(find_working_keys(encrypted_message, date))
  end

  def combine_keys(keys)
    keys.each_with_index.map do |key, index|
      if index == 0
        key
      else
        key[1]
      end
    end.join
  end

  def find_working_keys(encrypted_message, date)
    potential_keys = find_all_potential_keys(encrypted_message, date)
    potential_keys[0].each do |key_1|
      next if !key_is_valid?(potential_keys[1], key_1)
      key_2 = find_next_valid_key(potential_keys[1], key_1)
      next if !key_is_valid?(potential_keys[2], key_2)
      key_3 = find_next_valid_key(potential_keys[2], key_2)
      next if !key_is_valid?(potential_keys[3], key_3)
      key_4 = find_next_valid_key(potential_keys[3], key_3)
      return [key_1, key_2, key_3, key_4]
    end
  end

  def key_is_valid?(potential_key_set, key)
    potential_key_set.any?{|potential_key| potential_key[0] == key[1]}
  end

  def find_next_valid_key(potential_key_set, key)
    potential_key_set.find{|potential_key| potential_key[0] == key[1]}
  end

  def find_all_potential_keys(encrypted_message, date)
    all_potential_keys = Hash.new
    shifts_minus_offsets(encrypted_message, date).each_with_index do |key_value, index|
      all_potential_keys[index] = calculate_possible_key_values(key_value)
    end
    all_potential_keys
  end

  def calculate_possible_key_values(key_value)
    [
      first_key_value(key_value),
      (key_value + 27).to_s,
      (key_value + 54).to_s,
      (key_value + 81).to_s,
    ].reject{ |key_value| key_value.to_i >= 100}
  end

  def first_key_value(key)
    return "0" + key.to_s if key.to_s.length == 1
    key.to_s
  end

  def shifts_minus_offsets(encrypted_message, date)
    offsets = date_to_offsets(date)
    find_shifts(encrypted_message, date).each_with_index.map do |shift, index|
      shifted = shift - offsets[index]
      shifted %= 27 if shifted < 0
      shifted
    end
  end

end
