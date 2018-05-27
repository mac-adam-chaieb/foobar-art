require 'chroma'
require 'securerandom'
require 'rmagick'
require 'progressbar'

$number_of_covers = ARGV[0].to_i
$source_path = 'foobar.png'

def random_pair_of_matching_colours
  random_palette = [:complement, :split_complement, :tetrad, :triad, :analogous, :monochromatic].sample
  Chroma.paint(SecureRandom.hex(3)).palette.send(random_palette, as: :name).sample(2)
end

def generate_cover(path)
  base_image = Magick::ImageList.new($source_path)
  base_image.level_colors(*random_pair_of_matching_colours).write(path)
end

puts "Generating #{$number_of_covers} Foobar covers..."
progress = ProgressBar.create(total: $number_of_covers)

$number_of_covers.times do |index|
  generate_cover("covers/foobar-cover-#{index}.png")
  progress.increment
end

puts "Done."
