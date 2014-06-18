# Triangulator

This app demonstrates how to triangulate distance between iBeacons.

## Instructions

Click on the bottom-left triangle icon (it should turn gray) to configure the iBeacons you have to match their real-life location, and click again on the triangle when you are done.

Next, click on the bottom-right scan icon to start scanning for iBeacons.

## Notes

* The app is hardcoded to use 3 iBeacons. The triangulation code could handle more of them, but the iBeacon setup would need to be modified to support this.
* The triangulation code doesn't handle the 0 < n < 3 signal case. When there are only one or two iBeacons present, we should do something different with the UI. The same goes for 0 iBeacons.


## Shamelessly Stolen Artwork

Estimote iBeacons: From http://www.uidesignbyadam.com/blog/

Wallpaper: Interfacelift (Sandy Cay is the current background)