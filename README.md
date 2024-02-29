[funny.computer.daz.cat](http://funny.computer.daz.cat)
=======================================================

you will need:

- soupault
- rsync
- colordiff

to build /site/ into /build/:

```
$ ./build.sh
```

to see what would change if you deployed (after building):

```
$ ./diff.sh
```

to deploy /build/ to /production/:

```
$ ./deploy.sh
```

be sure to commit both /site/ and /production/ :)
