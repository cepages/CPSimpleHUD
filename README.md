# README #

SimpleHUD works on any iOS version and is compatible with swift.

Currently it has three modes:

- Unlimited

Default mode, but to set Unlimited again: 

```
let hud = CPSimpleHUD.shareWaitingView
hud.waitingMode = .Unlimited
``` 


![HUD.gif](https://bitbucket.org/repo/GAA9rq/images/3304417787-HUD.gif)

- SmallCubesLinear

To set SmallCubesLinear: ```hud.waitingMode = .SmallCubesLinear``` 

![hudborder](https://cloud.githubusercontent.com/assets/5259830/4565408/95b07658-4f1f-11e4-9515-d684918963d6.gif)

- SmallCubesBorders

To set SmallCubesLinear: ```hud.waitingMode = .SmallCubesBorders``` 


### How use it ###

To show the HUD just:

CPSimpleHUD.shareWaitingView.show()

To show the HUD just:

CPSimpleHUD.shareWaitingView.hide()

The dark view in the background and the label are customisable.


### How do I get set up? ###

Frameworks required:

* Foundation.framework
* UIKit.framework

Just copy the CPSimpleHUD.swift file in your project.
