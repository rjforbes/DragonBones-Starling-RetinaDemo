package
{

    
    import starling.display.Sprite;
    import starling.utils.AssetManager;
    
    import utils.ProgressBar;

    /** The Root class is the topmost display object in your game. 
	 *  It is a general scene switcher and will contain any globally accessable items liek menus and transition screens.
     *  It listens for bubbled events from the scenes to trigger events.
	 *  Keep this class rather lightweight: it controls the high level behaviour of your game. */
    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
		
        private var mSceneContainer:Sprite;
		private var mActiveScene:Sprite;


        
        public function Root(charString:String = "")
        {
			
            // not more to do here -- Startup will call "start" immediately.
        }
        
        public function start(assets:AssetManager):void
        {
			// Initialize UI Theme (Feathers,  need full tempalte for use)
			// new MetalWorksMobileTheme();
			
			// the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"
            sAssets = assets;
        
            // The AssetManager contains all the raw asset data, but has not created the textures
            // yet. This takes some time (the assets might be loaded from disk or even via the
            // network), during which we display a progress indicator. 
            
			
            var progressBar:ProgressBar = new ProgressBar(175, 20);
            progressBar.x = (Costanza.STAGE_WIDTH/2)  - (progressBar.width/2);
            progressBar.y = Costanza.STAGE_HEIGHT * 0.85;
            addChild(progressBar);
			
            
            assets.loadQueue(function onProgress(ratio:Number):void
            {
                progressBar.ratio = ratio;
                
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                
                if (ratio == 1){
					mSceneContainer = new Sprite();
					addChild(mSceneContainer);
					
					mActiveScene = new Lobby();
					mSceneContainer.addChild(mActiveScene);
					
					removeChild(progressBar);
				};
            });
        }
		
        public static function get assets():AssetManager { return sAssets; }
    }
}