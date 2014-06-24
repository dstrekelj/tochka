import com.haxepunk.Engine;
import com.haxepunk.HXP;

import flash.net.SharedObject;

class Main extends Engine
{
	/*	Necessary for the creation of the SharedObject object used to save
	**	high scores and other progress. Used in setupSharedObject() function.
	*/
	private var so : SharedObject;
	
	/*	Constructor for the Main class extending the Engine class.
	**	@param	width		The width of the game
	**	@param	height		The height of the game
	**	@param	frameRate	The game framerate, in frames per second
	**	@param	fixed		If a fixed framerate should be used
	*/
	override public function new ( width : Int = 0,
								  height : Int = 0,
								  frameRate : Float = 60,
								  fixed : Bool = false )
	{
		super( 640, 480, frameRate, fixed );
	}
	
	/*	Main game class, manages the game loop.
	*/
	public static function main ()
	{
		new Main();
	}
	
	/*	Called after the Engine object has been created in main().
	*/
	override public function init ()
	{
		/*	If building in debug mode, enable the console.
		*/
#if debug
		HXP.console.enable();
#end
		/*	Set up the Shared Object used to store high scores.
		*/
		setupSharedObject();
		/*	Create and call the game's title screen.
		*/
		HXP.scene = new scenes.TitleScene();
	}
	
	/*	Sets up a Flash SharedObject for storing game progress
	**	(high scores) locally. Available on all targets.
	**
	**	Tries creating a local SharedObject. Catches error thrown by
	**	constructor if creation of a local SharedObject isn't possible.
	**
	**	Initializes sessionbest variable and score (overall) variable,
	**	if the score variable isn't present already (if the game was
	**	never played before).
	*/
	private function setupSharedObject () : Void
	{		
		try {
			so = SharedObject.getLocal( "highscore" );
		} catch ( error : Dynamic ) {
			trace("SharedObject error: " + error);
		}
		
		so.data.sessionbest = 0;
		so.flush();
			
		if ( so.data.score == null ) {
			so.data.score = 0;
			so.flush();
		}
	}
	
	/*	focusLost() and focusGained() make sure the game state is paused when
	**	the game window is not in focus. Works on Android and Flash targets.
	*/
	override public function focusLost ()
	{
		paused = true;
	}
	
	override public function focusGained ()
	{
		paused = false;
	}
}