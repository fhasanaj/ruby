require_relative 'rosette_api_error'

# This class encapsulates parameters that are needed for name-translation in
# Rosette API.
class NameTranslationParameters
  # Name's entity type (PERSON, LOCATION, ORGANIZATION) (optional)
  attr_accessor :entity_type
  # genre to categorize the input data
  attr_accessor :genre
  # Name to translate
  attr_accessor :name
  # ISO 693-3 code of the name's native language the name originates in (optional)
  attr_accessor :source_language_of_origin
  # ISO 693-3 code of the name's language of use (optional)
  attr_accessor :source_language_of_use
  # ISO 15924 code of the name's script (optional)
  attr_accessor :source_script
  # ISO 639-3 code of the translation language
  attr_accessor :target_language
  # Transliteration scheme for the translation (optional)
  attr_accessor :target_scheme
  # ISO 15924 code of name's script (optional)
  attr_accessor :target_script

  def initialize(name, target_language, options = {}) #:notnew:
    options = {
      entity_type: nil,
      genre: nil,
      source_language_of_origin: nil,
      source_language_of_use: nil,
      source_script: nil,
      target_scheme: nil,
      target_script: nil
    }.update options
    @name = name
    @entity_type = options[:entity_type]
    @genre = options[:genre]
    @source_language_of_origin = options[:source_language_of_origin]
    @source_language_of_use = options[:source_language_of_use]
    @source_script = options[:source_script]
    @target_language = target_language
    @target_scheme = options[:target_scheme]
    @target_script = options[:target_script]
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    self.to_hash.select { |_key, value| !value.nil? }
        .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
        .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      entity_type: @entity_type,
      genre: @genre,
      name: @name,
      source_language_of_origin: @source_language_of_origin,
      source_language_of_use: @source_language_of_use,
      source_script: @source_script,
      target_language: @target_language,
      target_scheme: @target_scheme,
      target_script: @target_script
    }
  end
end
