/**
 * Created by Max Rozdobudko on 3/20/15.
 */
package
{
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.core.FeathersControl;
import feathers.themes.MetalWorksMobileTheme;

import flash.media.CameraRoll;

import starling.events.Event;

public class Root extends FeathersControl
{
    public function Root()
    {
        super();
    }

    protected var label:Label;

    protected var button:Button;

    override protected function initialize():void
    {
        super.initialize();
    }

    public function start():void
    {
label = new Label();
label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
label.wordWrap = true;
addChild(label);

button = new Button();
button.label = "Camera";
button.addEventListener(Event.TRIGGERED, function(event:Event):void
{
    if (CameraRoll.supportsBrowseForImage)
    {
        var camera:CameraRoll = new CameraRoll();

        camera.browseForImage();
    }
});
addChild(button);

invalidate(INVALIDATION_FLAG_LAYOUT);
    }

    override protected function draw():void
    {
        super.draw();

        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        sizeInvalid = this.autoSizeIfNeed() || sizeInvalid;

        if (sizeInvalid)
        {
            label.x = 0;
            label.y = 0;
            label.width = actualWidth;
            label.validate();

            button.validate();
            button.x = (actualWidth - button.width) / 2;
            button.y = label.x + label.height + 20;
        }
    }

    protected function autoSizeIfNeed():Boolean
    {
        var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
        var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN

        if(!needsWidth && !needsHeight)
        {
            return false;
        }

        var newWidth:Number = this.explicitWidth;
        if (needsWidth)
        {
            newWidth = this.stage.stageWidth;
        }

        var newHeight:Number = this.explicitHeight;
        if (needsHeight)
        {
            newHeight = this.stage.stageHeight;
        }

        return this.setSizeInternal(newWidth, newHeight, false);
    }

    override protected function feathersControl_addedToStageHandler(event:Event):void
    {
        super.feathersControl_addedToStageHandler(event);

        new MetalWorksMobileTheme(true);

        this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
    }

    override protected function feathersControl_removedFromStageHandler(event:Event):void
    {
        super.feathersControl_removedFromStageHandler(event);

        this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
    }

    protected function stage_resizeHandler(event:Event):void
    {
        this.invalidate(INVALIDATION_FLAG_SIZE);
    }

    private function button_triggeredHandler(event:Event):void
    {
        if (CameraRoll.supportsBrowseForImage)
        {
            var camera:CameraRoll = new CameraRoll();

            camera.browseForImage();
        }
    }
}
}
