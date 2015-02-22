package Code.Model {
	import flash.events.Event;
	
	public final class ModelEvent extends Event {
		public static const MakeGenericEntity:String = "a";
		public static const RemoveGenericEntity:String = "b";
		public static const AddQuirk:String = "c";
		public static const RemoveQuirk:String = "d";
		public static const RequestMakeGenericEntity:String = "e";
		public static const DistortionStart:String = "i";
		public static const DistortionDone:String = "h";
		public static const GameOver:String = "j";
		public static const JumpLand:String = "k";
		public static const GameOverOver:String = "l";
		
		public var data:* = null;
		
		public function ModelEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}