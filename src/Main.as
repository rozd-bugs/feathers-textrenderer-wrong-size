package {

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.RenderTexture;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import starling.utils.SystemUtil;

[SWF(width="320", height="480", frameRate="30", backgroundColor="#FFFFFF")]
public class Main extends Sprite
{
    private const StageWidth:int  = 320;
    private const StageHeight:int = 480;

    private var mStarling:Starling;

    public function Main()
    {
        // We develop the game in a *fixed* coordinate system of 320x480. The game might
        // then run on a device with a different resolution; for that case, we zoom the
        // viewPort to the optimal size for any display and load the optimal textures.

        var iOS:Boolean = SystemUtil.platform == "IOS";
        var stageSize:Rectangle  = new Rectangle(0, 0, StageWidth, StageHeight);
        var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        var viewPort:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL);
        var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640

        Starling.multitouchEnabled = true; // useful on mobile devices
        Starling.handleLostContext = true; // recommended everywhere when using AssetManager
        RenderTexture.optimizePersistentBuffers = iOS; // safe on iOS, dangerous on Android

        mStarling = new Starling(Root, stage, viewPort, null, "auto", "auto");
        mStarling.stage.stageWidth    = StageWidth;  // <- same size on all devices!
        mStarling.stage.stageHeight   = StageHeight; // <- same size on all devices!
        mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function(event:Object):void
        {
            Root(mStarling.root).start();
        });

        mStarling.start();

        // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
        // would report a very long 'passedTime' when the app is reactivated.

        if (!SystemUtil.isDesktop)
        {
            NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
            NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(true); });
        }
    }

}
}
