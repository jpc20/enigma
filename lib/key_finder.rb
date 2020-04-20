require_relative "machine"
require_relative "crackable"

class Keyfinder < Machine
  include Crackable

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
