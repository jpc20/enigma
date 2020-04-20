module Crackable

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
  
end
