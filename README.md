![Banner](https://user-images.githubusercontent.com/47299190/173126384-a05b7f9f-0ab8-4c33-87ce-dabbeeaa2681.png)

<p align="center">Power of <strong>ffmpeg</strong> for normal users.</p></br>

![Preview](https://user-images.githubusercontent.com/47299190/173125771-6df15bc1-102e-4658-8afb-b07be7707bfd.png)

[![Github Page](https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/pages/pages-build-deployment)

[![Flutter](https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/flutter.yml/badge.svg)](https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/flutter.yml)

## Minor Changes

### Windows

```diff
// windows/runner/main.cpp
+ Win32Window::Size size(1280, 720);
+ if (!window.CreateAndShow(L"Osumffmpeg (Beta)", origin, size)) {

- Win32Window::Size size(750, 600);
- if (!window.CreateAndShow(L"osumffmpeg", origin, size)) {
```
