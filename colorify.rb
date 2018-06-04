require 'rmagick'
require 'progressbar'
require 'uri'
require 'json'
require 'net/http'

$number_of_palettes = ARGV[0].to_i
$number_of_covers_per_palette = ARGV[1].to_i
$randomize_model = ARGV[2].to_i
$number_of_covers = $number_of_palettes * $number_of_covers_per_palette
$base_image = Magick::ImageList.new('foobar.png')
$colormind_model_list_uri = URI.parse("http://colormind.io/list/")
$colormind_random_palette_uri = URI.parse("http://colormind.io/api/")


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
  random_palette.permutation(2).to_a.sample($number_of_covers_per_palette)
end

def generate_cover(path, *pair_of_colours)
  $base_image.level_colors(*pair_of_colours).write(path)
end


puts "Generating #{$number_of_covers} Foobar covers..."
progress = ProgressBar.create(total: $number_of_covers)

$number_of_palettes.times do |index|
  pairs = pairs_from_random_palette
  pairs.each.with_index do |pair_of_colours, pair_index|
    generate_cover("covers/foobar-cover-#{index}-#{pair_index}.png", *pair_of_colours)
    progress.increment
  end
end

puts "Done."
