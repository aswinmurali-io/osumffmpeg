**(Work in progress)**

<a href="https://github.com/aswinmurali-io/osumffmpeg/">
  <h1 align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/47299190/173841870-4a4ee13d-ef3a-4585-8b57-aa5f8f3762cc.png">
      <img alt="Osumffmpeg" src="https://user-images.githubusercontent.com/47299190/173613380-7a2f4ec5-bc22-467b-9606-e839e846a44b.png">
    </picture>
  </h1>
</a>

<p align="center">
  <a href="#">
    <img align="center" src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />  
    <img align="center" src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />  
    <img align="center" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" />  
    <img align="center" src="https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" />
    <img align="center" src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
    <img align="center" src="https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=apple&logoColor=white" />
    <img align="center" src="https://img.shields.io/badge/apple%20silicon-333333?style=for-the-badge&logo=apple&logoColor=white" />
   </a>
  </br>
  </br>
  <a href="#">
    <!-- <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/pages/pages-build-deployment/badge.svg" /> -->
    <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/innosetup.yml/badge.svg" />
    <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/linux.yml/badge.svg" />
    <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/windows.yml/badge.svg" />
    <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/snapcraft.yml/badge.svg" />
    <img align="center" src="https://github.com/aswinmurali-io/osumffmpeg/actions/workflows/docker.yml/badge.svg" />
    <img align="center" src="https://www.repostatus.org/badges/latest/active.svg" />  
   </a>

   <!-- <a href="https://launchpad.net/osumffmpeg/">
    <img src="http://media.launchpad.net/lp-badge-kit/launchpad-badge-w160px.png"
         alt="Launchpad logo"/>
    </a> -->
</p>

![Preview](https://user-images.githubusercontent.com/47299190/173613514-03d778b7-a272-4a54-8aba-c8b079d34ffb.png)

## License

Osumffmpeg has a GNU Lesser General Public License v2.1, as found in the [LICENSE](https://github.com/aswinmurali-io/osumffmpeg/blob/main/LICENSE) file.

## Installing

`osumffmpeg` depends on `ffmpeg` as an external dependency.

<!-- <a href="https://snapcraft.io/osumffmpeg">
  <img alt="Get it from the Snap Store" src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg" />
</a> -->

### Building from source via `Dockerfile`

```bash
docker build . -f Dockerfile -t osumffmpeg --squash
docker run -d --name osumffmpeg osumffmpeg
```

### Building from source

```bash
git clone https://github.com/aswinmurali-io/osumffmpeg.git
cd osumffmpeg
flutter pub get
flutter build <PLATFORM>
```
