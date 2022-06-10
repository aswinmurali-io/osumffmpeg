# osumffmpeg

Provide the power of `ffmpeg` for normal users.

## TODO

- Right now tab switching causes the same ffmpeg output stream in **convert media page** to be listened again. Temp fix is to return as broadcase stream. But ideal fix would be to stop multiple listening.

- User path is censored by osumffmpeg from entering in the log but ffmpeg output may still output path. Need to find a way to mask it.

## Minor Changes

### Windows

```diff
// windows/runner/main.cpp
+ Win32Window::Size size(1280, 720);
+ if (!window.CreateAndShow(L"Osum FFMPEG (Beta)", origin, size)) {

- Win32Window::Size size(750, 600);
- if (!window.CreateAndShow(L"osumffmpeg", origin, size)) {
```
