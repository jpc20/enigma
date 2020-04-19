require_relative "machine"

class Encryptor < Machine

  def encrypt(message, key = generate_key, date = todays_date)
    {
      encryption: encrypt_message(message, key, date),
      key: key,
      date: date
    }
  end

  def encrypt_message(message, key, date)
    encrypted = ""
    shifts = create_shifts(key, date)
    split_message(message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        encrypted.concat(encrypt_character(char, shift_value))
      end
    end
    encrypted
  end

  def encrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) + shift) % 27
    @alphabet[new_index]
  end

end
