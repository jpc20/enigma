require_relative "machine"
require_relative "key_finder"
require_relative "shiftable"

class Decryptor < Machine
  include Shiftable

  def initialize
    @key_finder = Keyfinder.new
    super
  end

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

  def find_key(encrypted_message, date)
    @key_finder.find_key(encrypted_message, date)
  end

end
