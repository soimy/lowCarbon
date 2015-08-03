package object 
{
	import com.greensock.TweenLite;
	import com.shader.math.Interp;
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class MovingEnv extends Sprite 
	{
		private var _particles:Vector.<Particle>;
		private var _nearClipPlane:Number = 0;
		private var _farClipPlane:Number = 7000;
		
		private var _isPlaying:Boolean;
		private var _sampleRate:Number = 200;
		private var _deltaTime:Number = 0;
		public var globalSpeed:Number = 1;
		private var _baseSpeed:Number = -100;
		
		private var _particleSetup:Array;
		
		public function MovingEnv(particleSetup:Array) 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
			//particleSetup = new Array(0, 200, 60, 1300, 60, 1300, 100, 1300); // cloud, tree, bush, grass
			_particleSetup = particleSetup;
		}
		
		private function destory(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			stop();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.removeChildren();
			
			_particles = new Vector.<Particle>();
			_isPlaying = false;
			if(_nearClipPlane == 0) _nearClipPlane = stage.getCameraPosition().z;
			
			stage.projectionOffset = new Point(0, 80);
			
			for (var j:int = 0; j < _particleSetup.length/2; j++) 
			{
				if(_particleSetup[j*2])
					generateParticles(j, _particleSetup[j*2], _particleSetup[j*2+1]);
			}
			
			_particles.sort(orderZ);
			
			
		}
		
		private function orderZ(a:Particle, b:Particle):Number 
		{
			return a.z > b.z ? -1 : 1;
		}
		
		private function generateParticles(typ:uint, _num:uint, height:int):void 
		{
			var particle:Particle;
			var num:uint = _num;
			while( num > 0 ) 
			{
				particle = new Particle(typ);
				particle.z = Interp.remap(_nearClipPlane, _farClipPlane, Math.random());
				particle.y = height;
				switch (typ) 
				{
					case 0: // cloud
						particle.width *= 6;
						particle.height *= 6;
						particle.x = Interp.remap(-540, 1620, Math.random());
						//particle.y = 200;
						break;
					case 1: // tree of scene1
						particle.width *= 3;
						particle.height *= 3;
						particle.x = Math.random() > 0.5 ? Interp.remap(-1000, 200, Math.random()) : Interp.remap(880, 2080, Math.random());
						//particle.y = 1300;
						break;
					case 2: // bush of scene1
						particle.width *= 0.75;
						particle.height *= 0.75;
						particle.x = Math.random() > 0.5 ? Interp.remap(-500, 250, Math.random()) : Interp.remap(830, 1580, Math.random());
						//particle.y = 1300;
						break;
					case 3: // grass
						particle.width *= 0.25;
						particle.height *= 0.25;
						particle.x = Math.random() > 0.5 ? Interp.remap(-100, 250, Math.random()) : Interp.remap(830, 1180, Math.random());
						//particle.y = 1300;
						break;
					case 4: // road line
						particle.x = 540;
						particle.width *= 0.75;
						particle.height *= 2;
						particle.rotationX = Math.PI * 0.5;
						particle.z = Interp.remap(_nearClipPlane, _farClipPlane, num / _num);
						break;
					case 5: // tree of scene2
						particle.width *= 2;
						particle.height *= 2;
						particle.x = Math.random() > 0.5 ? Interp.remap(-1000, 200, Math.random()) : Interp.remap(880, 2080, Math.random());
						break;
					case 6: // bush of scene2
						particle.width *= 0.75;
						particle.height *= 0.75;
						particle.x = Math.random() > 0.5 ? Interp.remap(-500, 250, Math.random()) : Interp.remap(830, 1580, Math.random());
						//particle.y = 1300;
						break;
					case 7: // start line
						particle.x = 540;
						particle.width *= 2;
						particle.height *= 2;
						particle.rotationX = Math.PI * 0.5;
						particle.z = _nearClipPlane + 20;
					default:
				}
				num--;
				_particles.push(particle);
			}
		}
		
		public function addToScene():void 
		{
			this.removeChildren();
			for (var i:int = 0; i < _particles.length; i++) 
			{
				addChild(_particles[i]);
			}
		}
		
		public function play():void 
		{
			if (!_isPlaying) {
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
				_isPlaying = true;
			}
		}
		
		public function stop():void 
		{
			if (_isPlaying) {
				_isPlaying = false;
			}
		}
		
		private function onUpdate(e:EnterFrameEvent):void 
		{
			for (var i:int = 0; i < _particles.length; i++) 
			{
				_particles[i].z += e.passedTime * globalSpeed * _baseSpeed;
				//_particles[i].tint = Interp.linstep(_nearClipPlane+(_farClipPlane - _nearClipPlane)* 0.5, _farClipPlane, _particles[i].z) * 0.5;
			}
			
			if (_deltaTime > _sampleRate) {
				_deltaTime = 0;
				onFixUpdate();
			} else {
				_deltaTime += e.passedTime * 1000;
			}
		}
		
		private function onFixUpdate():void 
		{
			for (var i:int = 0; i < _particles.length; i++) 
			{
				if (_particles[i].z < _nearClipPlane) {
					_particles[i].z += _farClipPlane - _nearClipPlane;
					
					if (_isPlaying){
						this.addChildAt(_particles[i], 0);
						TweenLite.from(_particles[i], 0.5, { alpha:0 } );
					}
					else {
						this.removeChild(_particles[i]);
						if (this.numChildren == 0){
							this.removeEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
							this.visible = false;
							//if(parent)
								//parent.removeChild(this);
						}
					}
				}
			}
		}
		
		public function get farClipPlane():Number 
		{
			return _farClipPlane;
		}
		
		public function set farClipPlane(value:Number):void 
		{
			_farClipPlane = value;
		}
		
		public function get nearClipPlane():Number 
		{
			return _nearClipPlane;
		}
		
		public function set nearClipPlane(value:Number):void 
		{
			_nearClipPlane = value;
		}
		
		
	}

}