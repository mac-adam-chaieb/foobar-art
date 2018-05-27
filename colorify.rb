require 'chroma'
require 'securerandom'
require 'rmagick'
require 'progressbar'

$number_of_covers = ARGV[0].to_i
$source_path = 'foobar.png'

def get_random_pair_of_matching_colours
  random_palette = [:complement, :split_complement, :tetrad, :analogous, :monochromatic].sample
  Chroma.paint(SecureRandom.hex(3)).palette.send(random_palette, as: :name).sample(2)
end

puts "Generating #{$number_of_covers} Foobar covers..."
progress = ProgressBar.create(total: $number_of_covers)
$number_of_covers.times do |index|
  logo_colour, background_colour = *get_random_pair_of_matching_colours
  image = Magick::ImageList.new($source_path)
  logo_image = image.level_colors(background_colour, logo_colour)
  logo_image.write("covers/foobar-cover-#{index}.png")
  progress.increment
end
puts "Done."
