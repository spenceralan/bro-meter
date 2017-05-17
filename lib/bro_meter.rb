require "nokogiri"
require "open-uri"
require "words_counted"
require "dictionary_lookup"

class Meter
  def initialize(site)
    self.site = site
  end
  
  def site_to_text
    Nokogiri::HTML(open(site)).text
  end

  def word_count
    WordsCounted.count(site_to_text).token_frequency.to_h
  end

  def valid_words
    valid_words = Hash.new
    word_count.each_pair do |word, number|
      puts word
      if word == "hash" ||
        word == "single" ||
        word == "even"
        next
      elsif DictionaryLookup::Base.define(word).any?
        puts word
        valid_words[word] = number
      end
    end
    valid_words
  end


  private

  attr_accessor :site

end

count = Meter.new("http://www.rubydoc.info/gems/words_counted/0.1.1")

puts count.valid_words.inspect



# puts DictionaryLookup::Base.define("yell").inspect
# if word is not in the dictionary it returns an empty array