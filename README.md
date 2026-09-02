# CardViewer

CardViewer is an iOS app for organizing a personal sports-card collection. It
uses SwiftUI to create folders, add and edit cards, capture or select front and
back photos, browse card details, and scan QR codes.

## Highlights

- Local, on-device folder and card persistence.
- Photo Library and custom camera flows for front and back card images.
- QR-scanning support and player-name autocomplete.
- Optional NFL fantasy-projection lookup through RapidAPI.

## Run locally

1. Open `CardViewer.xcodeproj` in a current version of Xcode.
2. Let Swift Package Manager resolve `SwiftyJSON` and `SwiftSoup`.
3. Select an iOS simulator or connected device, then build and run.
4. For the optional fantasy-projection lookup, set `RAPIDAPI_KEY` as an
   environment variable in your local Xcode scheme. Do not place a credential
   in source files or commit it to this repository.

## Privacy and data

Cards, folders, and photos are stored locally on the device. This repository
contains no API credentials, account data, or user collection data.

## Project structure

```text
CardViewer/Card/     Card models, detail screens, and add/edit flows
CardViewer/Folder/   Folder models, persistence, and list views
CardViewer/Other/    App entry point, networking, and shared helpers
CardViewer/QRScanner.swift  QR-scanning support
```

## Status

This is a personal learning project. The optional third-party API can change
independently of the app, so its lookup feature may require endpoint or pricing
updates from RapidAPI.
