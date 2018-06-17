#!/usr/bin/env ruby
require 'progressbar'
require 'uri'
require 'json'
require 'net/http'
require 'optparse'

$number_of_pairs = 1
$randomize_model = false
$colormind_model_list_uri = URI.parse("http://colormind.io/list/")
$colormind_random_palette_uri = URI.parse("http://colormind.io/api/")

OptionParser.new do |opts|
  opts.banner = "Usage: bin/colour-pair-gen [options]"

  opts.on("-r", "--randomize-model", "Randomize the color models in ColorMind. Default: 'default' model") do |_|
    $randomize_model = true
  end

  opts.on("-n", "--number-of-pairs n", "Number of pairs of colours to generate. Default: #{$number_of_pairs}") do |n|
    $number_of_pairs = n.to_i
  end

  opts.on("-h", "--help", "Shows this message") do |_|
    puts opts
    exit
  end  
end.parse!

def rgb_to_hex(rgb)
  hex_colour = rgb.map do |int|
    hex = int.to_s(16)
    hex = "0#{hex}" if hex.length == 1
    hex
  end.join

  "##{hex_colour}"
end

def random_palette
  model = if $randomize_model
    JSON.parse(Net::HTTP.get_response($colormind_model_list_uri).body)['result'].sample
  else
    'default'
  end

  request = Net::HTTP::Post.new($colormind_random_palette_uri)
  request.body = "{\"model\":\"#{model}\"}"

  response = Net::HTTP.start($colormind_random_palette_uri.hostname, $colormind_random_palette_uri.port) do |http|
    http.request(request)
  end

  JSON.parse(response.body)['result'].map { |rgb_color| rgb_to_hex(rgb_color) }
end

def pairs_from_random_palette
  random_palette.permutation(2).to_a.sample
end

def generate_cover(path, *pair_of_colours)
  $base_image.level_colors(*pair_of_colours).write(path)
end

output = []
puts "Generating #{$number_of_pairs} colour pairs..."
progress = ProgressBar.create(total: $number_of_pairs, length: 100)

$number_of_pairs.times do |index|
  pairs = pairs_from_random_palette
  output << { logo_colour: pairs.first, background_colour: pairs.last }
  progress.increment
end

puts output.to_json
puts "Done."
