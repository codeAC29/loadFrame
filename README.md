# loadFrame

As the name suggests, this repository provides ways to load frames from input video/camera.

## Prerequisites

[`Torch-OpenCV`](https://github.com/VisionLabs/torch-opencv) is used in this repository. Installation instructions can be found [`here](https://github.com/VisionLabs/torch-opencv/wiki/installation).

## Functionalities

+ Capture frames from camera at different resolutions (option `camRes`).
+ Rescale frame size grabbed from input video (option `ratio`).
+ Display the timing values (option `verbose`):
    + time taken to load a frame
    + time taken to display the loaded frame
    + frame rate (fps)

Example

```
qlua main.lua -i movie.mp4 -r 0.5 -v
```
This will use movie.mp4 as input and downsample it by two; alongwith that it will show the timing values.
