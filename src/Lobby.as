package {
	
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.factorys.StarlingFactory;
	import dragonBones.objects.ObjectDataParser;
	import dragonBones.objects.SkeletonData;
	import dragonBones.textures.StarlingTextureAtlas;
	
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Lobby extends Sprite {
		
		
		// DB stuff
		private var factory:StarlingFactory;
		private var armatures:Array;
		
		// Scene Objects
		private var sceneRoot:Sprite;
		
			
		public function Lobby(charString:String = "") {
			
			// DragonBones Setup
			factory = new StarlingFactory();
			
			var skeletonData:SkeletonData = ObjectDataParser.parseSkeletonData(Root.assets.getObject("skeleton"));
			factory.addSkeletonData(skeletonData);
			
			var texture:Texture = Root.assets.getTexture("texture");
			var textureAtlas:StarlingTextureAtlas = new StarlingTextureAtlas(texture, Root.assets.getObject("texture"),true);
			factory.addTextureAtlas(textureAtlas);
		
			addEventListener(starling.events.Event.ADDED_TO_STAGE, textureCompleteHandler);
			
		}
		
		
		private function textureCompleteHandler(evt:starling.events.Event):void {
			armatures = [];
			addObjects();
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
		
		
		private function addObjects():void
		{
			// Create main scene root
			sceneRoot = new Sprite();
			sceneRoot.x = Costanza.STAGE_OFFSET;
			addChild(sceneRoot);
		
			// Add warrior
			var armature:Armature;
			armature = factory.buildArmature("knight");
			armature.display.x = 512;
			armature.display.y = 300;
			sceneRoot.addChild(armature.display as Sprite);
			WorldClock.clock.add(armature);
			armatures.push(armature);
		}
		
		
		
	
		private function onEnterFrameHandler(evt:EnterFrameEvent):void
		{
			WorldClock.clock.advanceTime(-1);
		}
		
		public function destroyScene():void
		{
			var len:int = armatures.length;
			for (var i:int = 0; i < len; i++)
			{
				WorldClock.clock.remove(armatures[i]);
				armatures[i].dispose();
			}
			armatures.length = 0;
			sceneRoot.removeChildren(0,sceneRoot.numChildren-1,true);
			
		}
	
	
	}
}