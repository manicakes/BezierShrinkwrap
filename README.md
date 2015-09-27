# BezierShrinkwrap

The purpose of this library is to provide a rough outline for an image that has an alpha background.

The outline is provided as a `UIBezierPath`. The way to obtain it is via one of two methods provided an a extension to `UIImageView`:

```
  @IBOutlet weak imageView : UIImageView!

  override func viewDidAppear() {
    super.viewDidAppear()
    
    imageView.getBezierOutline(10, margin: 10) // synchronous

    imageView.getBezierOutlineAsync(10, margin : 10) { (bezier : UIBezierPath) -> Void in
      // completion block
    }
  }
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

BezierShrinkwrap is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BezierShrinkwrap"
```

## Author

Mani Ghasemlou, mani.ghasemlou@icloud.com

## License

BezierShrinkwrap is available under the MIT license. See the LICENSE file for more info.
