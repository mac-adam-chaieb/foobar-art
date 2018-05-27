# foobar-covers
A script to automatically generate covers for Foobar's SoundCloud page.

To get this running, simply do the following:
```
# Unless the covers directory already exists
mkdir covers

# This will generate a 100 Foobar covers in the covers directory
ruby colorify.rb 100
```

This script depends on the `rmagick`, `chroma`, and `progressbar` gems.
