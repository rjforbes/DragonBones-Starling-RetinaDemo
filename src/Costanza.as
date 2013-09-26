package
{
    import starling.errors.AbstractClassError;

    public class Costanza
    {
        public function Costanza() { throw new AbstractClassError(); }
        
		public static var IPAD_RETINA:Boolean = false;
		public static var STAGE_WIDTH:int  = 1024;
		public static var STAGE_HEIGHT:int = 768;
		public static var STAGE_OFFSET:int = 0;
		public static var SCALE_FACTOR:int = 1;
    }
}