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

  def decrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) - shift) % 27
    @alphabet[new_index]
  end
end
