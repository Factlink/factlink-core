class UsernameGenerator
  include ActiveSupport::Inflector

  MAX_SUFFIX_LENGTH = 5

  def generate_from name, max_length=10000000
    username = slugify name[0, max_length]
    return username if !block_given? || yield(username)

    suffix = '_' + rand(10*MAX_SUFFIX_LENGTH).to_s
    prefix = slugify name[0, max_length-suffix.size]
    username = prefix + suffix
    return username if yield(username)

    (0..100).each do
      username = slugify SecureRandom.uuid[0, max_length]
      return username if yield(username)
    end

    fail 'Could not find a valid username after 100 tries'
  end

  # Adapted from slugify in ActiveSupport
  def slugify(string)
    # replace accented chars with their ascii equivalents
    parameterized_string = transliterate(string)
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
