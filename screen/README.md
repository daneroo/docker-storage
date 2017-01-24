# Screen capture

- [Screen recoding OSX](http://www.makeuseof.com/tag/5-best-screen-recorders-capturing-mac-os-x/)

## Use QuickTime Plaver-> New Screen Recording
## Using Monosnap
## Rescaling

- `-vf scale=320:-1`
- `-vf scale=iw*.5:ih*.5`

```
ffmpeg -i Screen0.mov -vf scale=320:240 Screen0.mp4
ffmpeg -i ScaleCompute.mov -vf scale=iw*.5:-1 -r 10 ScaleCompute.mp4
```