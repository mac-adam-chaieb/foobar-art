# foobar-covers
A script to automatically generate covers for Foobar's SoundCloud page.

To get this running, simply do the following:
```
# Unless the covers directory already exists
mkdir covers

# This will generate a 100 Foobar covers in the covers directory, with lightness=l and saturation=s
ruby colorify.rb 100 :l :s
```

This script depends on the `rmagick`, `chroma`, `progressbar` and `color-generator` gems.
