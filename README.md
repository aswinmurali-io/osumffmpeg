![Banner](https://user-images.githubusercontent.com/47299190/173126384-a05b7f9f-0ab8-4c33-87ce-dabbeeaa2681.png)

<p align="center">Provide the power of <strong>ffmpeg</strong> to normal users.</p></br>

![Preview](https://user-images.githubusercontent.com/47299190/173125771-6df15bc1-102e-4658-8afb-b07be7707bfd.png)


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
