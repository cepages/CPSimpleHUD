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

To set SmallCubesLinear: 

```
      hud.waitingMode = .SmallCubesLinear
```

![hud](https://cloud.githubusercontent.com/assets/5259830/4565453/ec9cc994-4f1f-11e4-9e39-982cc67e6afa.gif)

- SmallCubesBorders

To set SmallCubesLinear: 

```
      hud.waitingMode = .SmallCubesBorders
``` 

![hudborder](https://cloud.githubusercontent.com/assets/5259830/4565408/95b07658-4f1f-11e4-9515-d684918963d6.gif)


### How use it ###

To show the HUD just:

CPSimpleHUD.shareWaitingView.show()

To show the HUD just:

CPSimpleHUD.shareWaitingView.hide()

The dark view in the background and the label are customisable.

### Autolayout

You can change the autolayout rules of the darkview and as a result the interior cubes will change:

```
        hud.heightDarkViewContraint.constant = 50;
        hud.widthDarkViewContraint.constant = 50;
```

![hudbordersmall](https://cloud.githubusercontent.com/assets/5259830/4565469/2b6a3d00-4f20-11e4-988d-ba1c42846b02.gif)

### How do I get set up? ###

Frameworks required:

* Foundation.framework
* UIKit.framework

Just copy the CPSimpleHUD.swift file in your project.
