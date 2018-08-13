# Youtube Tutorial
**Youtube Video Tutorial** - [Click here](https://youtu.be/6_dDsOsGuGo)

# SMPinView
Simple view which enables you to add sms pin code typing view easier. If you want to create views from storyboard and want to make it work to verify sms code, this class will help you.
Please note, while doing project I found to be easier in some scenario so I through to share with you all. Hope this will help someone.

## Getting Started

* Drag **SMPinView** file into your project and make sure you select **☑️Copy items if needed**.
* Drag and drop **UIView** in storyboard from **Object Library**.
* Assign **SMPinView** to it.
* Now add `UITextField`s as much you want for your app and provide class name as `SMPinTextField` from **Identity Inspector**
* Order you textfields and assign tags from **Attribute Inspector**. Make sure you textfields are as in order with your tags.
* Once you set you tags, now create an outlet of **SMPinView** to your controller. This will help to perform further actions.
* To get the value typed within textfields, just call `getPinViewText()` method from the **SMPinView** instance variable.
* That's it. 👍

## Author

* **Santosh Maharjan** - [santoshm.com.np](http://www.santoshm.com.np)

## License

This project is licensed under the MIT License - see the LICENSE file for more info.
