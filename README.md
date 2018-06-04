# foobar-covers
A script to automatically generate covers for Foobar's SoundCloud page.

To get this running, simply do the following:
```
# Unless the covers directory already exists
mkdir covers

# Generate covers
ruby colorify.rb :number_of_random_palettes :number_of_covers_per_palette [randomize_palette_model]
```

This script depends on the `rmagick`, and `progressbar` gems.
