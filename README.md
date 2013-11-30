# Kortkoll for iOS

Kortkoll is a pet project of [@blommegard](http://twitter.com/blommegard), [gellermark](http://dribbble.com/gellermark),  [@peterssonjesper](http://twitter.com/peterssonjesper) and [@wibron](http://twitter.com/wibron). It is an app that shows information about your [SL](http://sl.se/) Access Card.  
It is an iOS7+ only app and my playground for testing out new features in the iOS SDK.

We have wrapped the API, but it is still not very good to work with, mostly because of the auth procedure. As it looks like now, we have to auth every time we fetch the cards, resulting in we have to save the cridentials on the device, this is done safely in the keychain.  
There are a lot of [magic numbers](http://en.wikipedia.org/wiki/Magic_number_(programming)) in here, just a heads up and it is only localized in swedish for now.

The app is currently live in the [App Store](https://itunes.apple.com/se/app/kortkoll/id681422117) and was first developed on [Stockholm Startup Hack](http://www.sthlmstartuphack.com/).

## Why public?

The app is already free, so why not? I would love to get some feedback on my work and hopefully someone will join in and fix stuff. Another awesome thing with public repos is the free Travis CI integration! :)

## Getting Started

Run the following commands to get started:

    $ git clone https://github.com/Kortkoll/kortkoll-ios.git
    $ cd kortkoll-ios
    $ rake setup

Need help? Email <hej@kortkoll.nu> or open an issue with specifics.

## Contributing

If you want to fix bugs, I'll love you forever! If you want to add some features, I may not merge it. I'm sure it will be awesome, but defending Kortkoll's simplicity is my utmost duty. If you're feeling like implementing a feature, check out the [issues](https://github.com/Kortkoll/kortkoll-ios/issues) for things tagged with "feature".

## Interesting stuff

#### [KKHUD](https://github.com/kortkoll/kortkoll-ios/blob/master/Kortkoll/Controllers/KKHUD.h)
My take on custom alerts/HUDs, it would be awesome to make it even more general and clean it up a bit.

## License

Kortkoll is released under the MIT-license (see the LICENSE file)

While it is not strictly forbidden by the license, I would greatly appreciate it if you didn't redistribute this app exactly the way it is in the App Store. There's nothing stopping you, but please don't be a jerk.

