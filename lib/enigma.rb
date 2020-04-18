class Enigma

  attr_reader :alphabet
  def initialize
    @alphabet = ("a".."z").to_a << " "
  end

  def todays_date
    Date.today.strftime(("%d%m%y"))
  end

  def generate_key
    key = ""
    5.times{ key.concat(rand(0..9).to_s)}
    key
  end

  def encrypt(message, key = generate_key, date = todays_date)
    {
      encryption: encrypt_message(message, key, date),
      key: key,
      date: date
    }
  end

  def decrypt(encrypted_message, key, date = todays_date)
    {
      decryption: decrypt_message(encrypted_message, key, date),
      key: key,
      date: date
    }
  end

  def crack(encrypted_message, date = todays_date)
    {
      decryption: crack_message(encrypted_message, date),
      #key: key,
      date: date
    }
  end

  def encrypt_message(message, key, date)
    encrypted = ""
    shifts = create_shifts(key, date)
    split_message(message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        if alphabet.include?(char)
          new_index = (@alphabet.find_index(char) + shift_value) % 27
          encrypted.concat(@alphabet[new_index])
        else
          encrypted.concat(char)
        end
      end
    end
    encrypted
  end

  def decrypt_message(encrypted_message, key, date)
    decrypted = ""
    shifts = create_shifts(key, date)
    split_message(encrypted_message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        if alphabet.include?(char)
          new_index = (@alphabet.find_index(char) - shift_value) % 27
          decrypted.concat(@alphabet[new_index])
        else
          decrypted.concat(char)
        end
      end
    end
    decrypted
  end

  def crack_message(encrypted_message, date)
    cracked = ""
    shifts = find_shifts(encrypted_message, date)
    split_message(encrypted_message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        if alphabet.include?(char)
          new_index = (@alphabet.find_index(char) - shift_value) % 27
          cracked.concat(@alphabet[new_index])
        else
          cracked.concat(char)
        end
      end
    end
    cracked
  end

  def split_message(message)
    message.chars.each_slice(4).to_a.map do |chars|
      chars.map { |char| char.downcase }
    end
  end

  def split_key(key)
    key_array = []
    key.chars.each_cons(2){|chars| key_array << chars.join}
    key_array.map { |char| char.to_i }
  end

  def date_to_offsets(date)
    (date.to_i ** 2).to_s.chars.last(4).map { |char| char.to_i }
  end

  def create_shifts(key, date)
    split_key(key).zip(date_to_offsets(date)).map { |nums| nums.reduce(:+) }
  end

  def find_key(encrypted_message, date)
    key = ""
    offsets = date_to_offsets(date)
    find_shifts(encrypted_message, date).each_with_index do |shift, index|
      if shift - offsets[index] < 10 && index == 0
        key.concat("0" + (shift - offsets[index]).to_s)
      else
        (0..9).each do |num|
          if key.chars.pop.concat(num.to_s).to_i % 27 == shift
            key.concat((num - offsets[index]).to_s)
            break
          end
        end
      end
    end
    key
  end

  def find_shifts(encrypted_message, date)
    shifts = nil
    split_encrypted = split_message(encrypted_message)
    last_chars_length = split_encrypted.last.length
    if last_chars_length == 4
      shifts = split_encrypted.last.zip([" ", "e", "n", "d"]).map do |message_char, end_char|
        (@alphabet.find_index(message_char) - @alphabet.find_index(end_char))
      end
    elsif last_chars_length < 4
      shifts = split_encrypted.last.zip([" ", "e", "n", "d"].last(last_chars_length)).map do |message_char, end_char|
        (@alphabet.find_index(message_char) - @alphabet.find_index(end_char)) % 27
      end
      shifts << split_encrypted[-2].last(4 - last_chars_length).each_with_index.map do |char, index|
        (@alphabet.find_index(char) - @alphabet.find_index([" ", "e", "n", "d"][index])) % 27
      end
    end
    shifts.flatten
  end

end
