class UsernameGenerator
  include ActiveSupport::Inflector

  def generate_from name, max_length=10000000
    username = slugify name[0, max_length]
    return username if !block_given? || yield(username)

    prefix = slugify name[0, max_length-6]
    suffix = rand.to_s[2..6]
    username = prefix + '.' + suffix
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
    parameterized_string.gsub!(/[^A-Za-z0-9_\.]+/, '.')
    # No more than one of the separator in a row.
    parameterized_string.gsub!(/\.{2,}/, '.')
    # Remove leading/trailing separator.
    parameterized_string.gsub!(/^\.|\.$/, '')
    # Lower case
    parameterized_string.downcase
  end
end
