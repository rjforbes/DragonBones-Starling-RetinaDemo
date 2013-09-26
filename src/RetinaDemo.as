package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	public class RetinaDemo extends Sprite
	{
		
		private var mStarling:Starling;
		
		private var retinaTest:Boolean = true;
		
		public function RetinaDemo()
		{
			super();
			
			// Set retinaText to false to see SD version that works properly	
			if(retinaTest || Capabilities.screenResolutionX == 1536 && Capabilities.screenResolutionY == 2048){
				Costanza.IPAD_RETINA = true;
				Costanza.SCALE_FACTOR = 2;
			}
			

			var stageWidth:int   = Costanza.STAGE_WIDTH;
			var stageHeight:int  = Costanza.STAGE_HEIGHT;
			
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 1366x768; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			stage.align = StageAlign.TOP;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.NO_BORDER);
			
			var appDir:File = File.applicationDirectory;
			
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var assets:AssetManager = new AssetManager(Costanza.SCALE_FACTOR);
			
			trace("Scale factor is " + Costanza.SCALE_FACTOR);
			
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("textures/"+Costanza.SCALE_FACTOR+"x/")
			);
			
			
			// launch Starling
			
			mStarling = new Starling(Root, stage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.showStatsAt("center", "bottom");
			
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:Root):void
				{
					mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					app.start(assets);
					mStarling.start();
				});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 

			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start();});
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop();});
		}
	}
}