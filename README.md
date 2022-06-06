# osumffmpeg

Provide the power of `ffmpeg` for normal users.

# TODO

- Right now tab switching causes the same ffmpeg output stream in **convert media page** to be listened again. Temp fix is to return as broadcase stream. But ideal fix would be to stop multiple listening.

```cpp
// windows/runner/main.cpp
Win32Window::Size size(750, 600);
```
