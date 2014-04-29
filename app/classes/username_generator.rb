class UsernameGenerator
  include ActiveSupport::Inflector

  MAX_SUFFIX_LENGTH = 5

  # Generates a username from a full name, with some maximum length.
  # A block can be given to verify for a generated username if it is valid
  def generate_from name, max_length=10000000, &block
    generate_simple_username(name, max_length, &block) ||
      generate_username_with_suffix(name, max_length, &block) ||
      generate_random_username(max_length, &block) ||
      fail('Could not find a valid username after 100 tries')
  end

  private

  def generate_simple_username name, max_length, &block
    username = slugify name[0, max_length]
    return username if !block_given? || yield(username)

    nil
  end

  def generate_username_with_suffix name, max_length, &block
    100.times do
      suffix = '_' + rand(10**MAX_SUFFIX_LENGTH).to_s
      prefix = slugify name[0, max_length-suffix.size]
      username = prefix + suffix
      return username if yield(username)
    end

    nil
  end

  def generate_random_username max_length, &block
    100.times do
      username = slugify SecureRandom.uuid[0, max_length]
      return username if yield(username)
    end

    nil
  end

  # Adapted from slugify in ActiveSupport
  def slugify(string)
    # replace accented chars with their ascii equivalents
    parameterized_string = transliterate(string, '_')
    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/\W+/, '_')
    # No more than one of the separator in a row.
    parameterized_string.squeeze!('_')
    # Remove leading/trailing separator.
    parameterized_string.gsub!(/^_|_$/, '')
    # Lower case
    parameterized_string.downcase
  end
end
