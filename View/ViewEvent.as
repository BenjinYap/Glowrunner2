package Code.View {
	import flash.events.Event;
	
	public final class ViewEvent extends Event {
		public static const InputWindowEnter:String = "a";
		public static const InputWindowCancel:String = "b";
		public static const SongListDragStart:String = "c";
		public static const SongListsDragDone:String = "d";
		public static const RequestUserResize:String = "e";
		public static const RequestSelectSongs:String = "f";
		
		public var data:* = null;
		
		public function ViewEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}