//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//========================================================================================


package mx.automation.delegates.core
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.Automation;
	import mx.automation.IAutomationClass;
	import mx.automation.IAutomationEnvironment;
	import mx.automation.IAutomationManager;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.events.AutomationReplayEvent;
	import mx.core.Container;
	import mx.core.EventPriority;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  UIComponent class. 
	 * 
	 *  @see mx.core.UIComponent
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class UIComponentAutomationImpl extends EventDispatcher 
		implements IAutomationObject
	{
		include "../../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Registers the delegate class for a component class with automation manager.
		 *  
		 *  @param root DisplayObject object representing the application root. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function init(root:Object):void
		{
			Automation.registerDelegateClass(UIComponent, UIComponentAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param obj UIComponent object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function UIComponentAutomationImpl(obj:Object)
		{
			super();
			
			uiComponent = obj;
			
			if(!Automation.isGenericObject)
			{
				try{
					
					if(obj.initialized)
						componentInitialized();
					else
						obj.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
					if(obj.flexContextMenu != null)
						menuChangeHandler(null);
				}
				catch(e:Error){}
				obj.addEventListener("flexContextMenuChanged", menuChangeHandler);
						
				addMouseEvent(obj, MouseEvent.CLICK, mouseClickHandler,false,EventPriority.DEFAULT+1, true);
				obj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, EventPriority.DEFAULT+1, true);
				
				obj.addEventListener(EffectEvent.EFFECT_START, effectHandler, false, 0, true);
				obj.addEventListener(EffectEvent.EFFECT_END, effectHandler, false, 0, true);
			}
			Automation.isGenericObject = false;
		}
		
		
		private function isContainer(obj:Object):Boolean
		{
			
			var result:Boolean = false;
			if(getQualifiedClassName(obj).indexOf("container") > -1)
				result = true;
			
			var automationClass:IAutomationClass= IAutomationEnvironment(Automation.automationManager.automationEnvironment).getAutomationClassByInstance(obj);
			if(automationClass.objExtendedClassName.indexOf("container") > -1)
				result = true;
			
			return result;
		}
		
		protected function addMouseEvent(obj:Object, event:String, handler:Function , 
										 useCapture:Boolean = false , priority:int = 0, useWeekRef:Boolean = false):void
		{
			try
			{
				// special addevent listener on the container, which does not add the mouse shield.
				//Since $addEventListener is avilable via converting the object to Container the below statement does not holds true for us.
				//Hence we have to somehow remove the shield from the containers and hence below code is used.
				var containerClass:Class =uiComponent.loaderInfo.applicationDomain.getDefinition("mx.core::Container");
				
				if(obj is containerClass)
				{
					containerClass(obj).$addEventListener(event, handler, useCapture,0, useWeekRef);
				}
				else
					obj.addEventListener(event, handler, useCapture,priority, useWeekRef);	
			}
			catch(e:Error)
			{				
				//$addEventListener method is not there in Flex SDK 3.3 there were not be able to record click on containers for 3.3 SDK.
				//Added following code to make recording on containers happen for apps on SDK 3.3 or below.
				/*obj.addEventListener(event, handler, useCapture,priority, useWeekRef);
				try{
					if (event == MouseEvent.CLICK ||
						event == MouseEvent.DOUBLE_CLICK ||
						event == MouseEvent.MOUSE_DOWN ||
						event == MouseEvent.MOUSE_MOVE ||
						event == MouseEvent.MOUSE_OVER ||
						event == MouseEvent.MOUSE_OUT ||
						event == MouseEvent.MOUSE_UP ||
						event == MouseEvent.MOUSE_WHEEL)
					{
						obj.setStyle("mouseShield", false);
						obj.setStyle("mouseShieldChildren", false);
						
					}
				}catch(e:Error){}
				*/
			}
				
		} 
		
		protected function removeMouseEvent(obj:Object, event:String, handler:Function, useCapture:Boolean = false):void
		{
			if (obj is Container) 
				Container(obj).$removeEventListener(event, handler,useCapture);
				// special remove event listener on the container, corresponds to the special $addEventListener
				// which does not add the mouse shield.
			else
				obj.removeEventListener(event, handler,useCapture);
		} 
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 */
		protected var resourceManager:IResourceManager =
			ResourceManager.getInstance();
		
		/**
		 *  @private
		 */
		private var effectsPlaying:Boolean = false;
		
		/**
		 *  @private
		 */
		private var layoutPending:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------
		//  automationEnabled
		//---------------------------------
		public function get automationEnabled():Boolean
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if (uiComponent as IUIComponent)
				return (uiComponent as IUIComponent).enabled;
			
			return false;
		}
		
		//---------------------------------
		//  automationOwner
		//---------------------------------
		public function get automationOwner():DisplayObjectContainer
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if (uiComponent as IUIComponent)
				return (uiComponent as IUIComponent).owner;
			
			return null;
		}
		
		//---------------------------------
		//  automationParent
		//---------------------------------
		public function get automationParent():DisplayObjectContainer
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if (uiComponent as IUIComponent)
				return (uiComponent as IUIComponent).parent;
			
			return null;
		}
		
		
		//---------------------------------
		//  automationVisible
		//---------------------------------
		public function get automationVisible():Boolean
		{
			trace ("This method should not be called on delegate.Should have been called on the component");
			if (uiComponent as IUIComponent)
				return (uiComponent as IUIComponent).visible;
			
			return false;
		}
		
		//----------------------------------
		//  automationName
		//----------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get automationName():String
		{
			if (uiComponent is UIComponent)
				return UIComponent(uiComponent).id;
			
			return null;
		}
		
		/**
		 *  @private
		 */
		public function set automationName(value:String):void
		{
			uiAutomationObject.automationName = value;
		}
		
		//----------------------------------
		//  automationValue
		//----------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get automationValue():Array
		{
			return [ automationName ];
		}
		
		
		//------------- ---------------------
		//  recordClick
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the recordClick property.
		 */
		private var _recordClick:Boolean = false;
		
		/**
		 *  @private
		 *  Indicates whether this component should dispatch all click
		 *  events as replayable interaction
		 */
		public function get recordClick():Boolean
		{
			return _recordClick;
		}
		
		/**
		 *  @private
		 */
		public function set recordClick(val:Boolean):void
		{
			// we don't want to add/remove the event listeners multiple times
			if (_recordClick != val)
			{
				_recordClick = val;
				if (val)
					addMouseEvent(uiComponent,MouseEvent.CLICK, mouseClickHandler);
				else
					removeMouseEvent(uiComponent,MouseEvent.CLICK, mouseClickHandler);
			}
		}
		
		/**
		 *  @private
		 */
		public function get showInAutomationHierarchy():Boolean
		{
			trace("Reading should not be done here");
			return true;
		}
		
		/**
		 *  @private
		 */
		public function set showInAutomationHierarchy(value:Boolean):void
		{
			trace("Setting should not be done here");
			if(uiComponent is IAutomationObject)
				IAutomationObject(uiComponent).showInAutomationHierarchy = value;
		}
		
		/**
		 *  @private
		 */
		protected var _uiComponent:Object;
		
		/**
		 *  Returns the component instance associated with this delegate instance.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get uiComponent():Object
		{
			return _uiComponent;
		}
		
		/**
		 *  @private
		 */
		public function set uiComponent(obj:Object):void
		{
			_uiComponent = obj as Object;
		}
		
		/**
		 *  @private
		 */
		protected function get uiAutomationObject():Object
		{
			return _uiComponent as Object;
		}
		/**
		 *  @private
		 *  Dispatch a replayable interaction.
		 *
		 *  Usually a developer would intend to dispatch the event
		 *  as a normal event at the same time, so this function
		 *  will do a regular dispatchEvent() along with dispatching
		 *  to the AutomationManager.
		 *  If you wish to not dispatch the regular event,
		 *  set the second parameter to false.
		 *
		 *  This method will also test to make sure that the event
		 *  really should be dispatched by checking
		 *  shouldDispatchReplayableInteraction.
		 *  Component authors can override that method to ensure correct behavior.
		 *
		 *  @param event The Event to dispatch
		 *
		 *  @param doRegular If true (default) dispatch the regular event using
		 *  dispatchEvent(event)
		 *
		 *  @param cacheable
		 *
		 */
		public function recordAutomatableEvent(event:Event,
											   cacheable:Boolean = false):void
		{
			var am:IAutomationManager = Automation.automationManager;
			if (am && am.recording)
				am.recordAutomatableEvent(uiComponent as Object, event, cacheable);
		}
		
		/**
		 *  @private
		 *  Replay the specified interaction.
		 *  Returns whether or not a replay was successful.
		 *  A component author should probably call super.replayInteraction()
		 *  in case default replay behavior has been defined in a superclass.
		 *  UIComponent returns false since it does not know
		 *  how to replay any events.
		 *
		 *  @param event The event to replay
		 */
		public function replayAutomatableEvent(event:Event):Boolean
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			if (event is AutomationReplayEvent)
				event=(event as AutomationReplayEvent).replayableEvent;
			if (event is MouseEvent && event.type == MouseEvent.CLICK)
			{
				return help.replayClick(uiComponent, event as MouseEvent);
			}
			else if (event is MouseEvent && event.type == MouseEvent.DOUBLE_CLICK)
			{
				return help.replayMouseEvent(uiComponent, event as MouseEvent);
			}
			else if (event is KeyboardEvent)
			{
				return uiComponent.dispatchEvent(event);
			}
			else if (event is FocusEvent && 
				event.type == FocusEvent.KEY_FOCUS_CHANGE)
			{
				var ke:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
				ke.keyCode = Keyboard.TAB;
				ke.shiftKey = FocusEvent(event).shiftKey;
				uiComponent.dispatchEvent(ke);
				
				uiComponent.dispatchEvent(event);
				
				ke = new KeyboardEvent(KeyboardEvent.KEY_UP);
				ke.keyCode = Keyboard.TAB;
				
				if(UIComponent(uiComponent) && UIComponent(uiComponent).getFocus())
					return UIComponent(uiComponent).getFocus().dispatchEvent(ke);
				
				return false;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 *  Sets up an automation synchronization with the Layout Manager's UPDATE_COMPLETE event.
		 *  When certain actions are being replayed automation needs to wait before it can
		 *  replay the next event. This wait is required to allow the framework to complete
		 *  actions requested by the component. Normally a layout manager update complte event 
		 *  signals end of all updates. This method adds syncrhonization which gets signaled as 
		 *  complete when update_complete event is received.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function addLayoutCompleteSynchronization():void    
		{
			/*UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE, layoutHandler);
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			if (help && help.replaying)
			{
				layoutPending = true;
				help.addSynchronization(function():Boolean
				{
					return layoutPending == false;
				}, uiComponent);
			}*/
		}
		
		/**
		 *  Method which gets called after the component has been initialized.
		 *  This can be used to access any sub-components and act on them.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function componentInitialized():void 
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected function creationCompleteHandler(event:Event):void
		{
			componentInitialized();
			uiComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		/**
		 *  @private
		 *  This is for recording ENTER key for container.defaultButton
		 *  Should be overridden for components that already record ENTER key.
		 */
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var aoh:IAutomationObjectHelper = Automation.automationObjectHelper;
			if (event.keyCode == Keyboard.ENTER)
			{
				if (aoh && aoh.recording)
				{
					var x:int = 0;
					var ao:Object = null;
					var o:Object = event.target;
					//if (aoh.isAutomationComposite(o as IAutomationObject))
						//o = aoh.getAutomationComposite(o as IAutomationObject);
					while (o)
					{
						ao = Automation.getDelegate(o);
						if (ao)
							break;
						o = o.parent;
					}
					if(ao.hasOwnProperty("uiComponent"))
					{
						if (ao.uiComponent == uiComponent)
							recordAutomatableEvent(event, false);
					}
				}
			}   
		}
		
		public function genericKeyHandler(event:KeyboardEvent):void
		{
			// Only listen for events that have come from the accordion itself.
			if (event.target != uiComponent)
				return;
			
			recordAutomatableEvent(event);
		}
		private function menuChangeHandler(event:Event):void
		{
			Automation.automationManager2.registerNewFlexNativeMenu((uiComponent as UIComponent).flexContextMenu, (uiComponent as UIComponent).systemManager as DisplayObject);
			
		} 
		
		/**
		 *  @private
		 */
		private function mouseClickHandler(event:MouseEvent):void
		{
			var am:IAutomationManager = Automation.automationManager;
			if (recordClick && am && am.recording)
			{
				var ao:Object = null;
				var o:Object = event.target;
				while (o)
				{
					ao = o as Object;
					if (ao)
						break;
					o = o.parent;
				}
				if (ao == uiComponent)
					recordAutomatableEvent(event, false);							
				else if (ao.parent == uiComponent && !(ao.parent is DisplayObjectContainer))
					recordAutomatableEvent(event, false);
				//adding the below statement to enable recording on image,this had to be done specifically because
				//the above statement always evaluates to false in case an image is loaded using flex loader,but works fine
				//if embedded in the application directly,that is the image does not have its child as flexloader
				else if (ao.parent == uiComponent && getQualifiedClassName(event.currentTarget).indexOf("Image") > -1)
				{
					if(uiComponent.hasOwnProperty("showInAutomationHierarchy"))
					{
						if(uiComponent.showInAutomationHierarchy)
							recordAutomatableEvent(event, false);
					}
					
				}
				
			}
		}
		
		/**
		 *  @private
		 */
		private function effectHandler(ev:Event):void
		{
			/*...Change for Marshalling Support ...*/
			// only the events coming from the same applicaiton
			// needs to handled.
			var event:EffectEvent = ev as  EffectEvent;
			if (event == null)
				return ;
			if (event.type == EffectEvent.EFFECT_START)
			{
				effectsPlaying = true;
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				if (help && help.replaying)
				{
					help.addSynchronization(function():Boolean
					{
						return !effectsPlaying;
					});
				}
			}   
			else
			{
				effectsPlaying = false;
			}       
		}
		
		/**
		 *  @private
		 */
		protected function layoutHandler(event:FlexEvent):void
		{
			layoutPending = false;
			UIComponentGlobals.layoutManager.removeEventListener(FlexEvent.UPDATE_COMPLETE, layoutHandler);
		}
		
		/**
		 *  @private
		 */
		public function createAutomationIDPart(child:IAutomationObject):Object
		{
			/*if((uiComponent as UIComponent).flexContextMenu != null)
			{
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				return help.helpCreateIDPart(uiAutomationObject, child);
			}*/
			return null;
		}
		
		/**
		 *  @private
		 */
		public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array):Object
		{
			/*if ((uiComponent as UIComponent).flexContextMenu != null)
			{
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				return help.helpCreateIDPartWithRequiredProperties(uiAutomationObject, child,properties);
			}
			return null;*/
			return null;
		}
		
		/**
		 *  @private
		 */
		public function resolveAutomationIDPart(criteria:Object):Array
		{
			/*if ((uiComponent as UIComponent).flexContextMenu != null)
			{
				var help:IAutomationObjectHelper = Automation.automationObjectHelper;
				return help.helpResolveIDPart(uiAutomationObject, criteria);
			}
			return [];*/
			return null;
		}
		
		/**
		 *  @private
		 */
		public function get numAutomationChildren():int
		{
			if ((uiComponent as UIComponent).flexContextMenu != null)
				return 1;
			return 0;
		}
		
		/**
		 *  @private
		 */
		public function getAutomationChildAt(index:int):IAutomationObject
		{
			if((uiComponent as UIComponent).flexContextMenu != null)
				return (uiComponent as UIComponent).flexContextMenu as IAutomationObject;
			return null;
		}
				
		/**
		 *  @private
		 */
		public function getAutomationChildren():Array
		{
			try
			{
				if ((uiComponent as UIComponent).flexContextMenu != null)
					return [(uiComponent as UIComponent).flexContextMenu as IAutomationObject];
			}catch(e:Error)
			{}
			return null;
		}
		/**
		 *  @private
		 */
		public function get automationTabularData():Object
		{
			return null;    
		}
		
		/**
		 *  @private
		 */
		public function get owner():DisplayObjectContainer
		{
			return (uiComponent as IUIComponent).owner;
		}
		
		/**
		 *  @private
		 */
		public function set automationDelegate(val:Object):void
		{
			trace("Invalid setter function call. Should have been called on the component");
		}
		
		/**
		 *  @private
		 */
		public function get automationDelegate():Object
		{
			trace("Invalid getter function call. Should have been called on the component");
			return this;
		}
		
		/**
		 *  @private
		 */
		public function getLocalPoint(po1:Point, targetObj:Object):Point
		{
			//var p:Point = new Point(event.localX, event.localY);
			// when the dragevent base object on which the coordinate is recorded 
			// then the delegate of that componet needs to override the method.
			// refer for details in Chartbase
			return po1;
		}
		
		/**
		 *  @private
		 */
		public function isDragEventPositionBased():Boolean
		{
			// for almost all components it is not.
			// however for compoents like chart it is coordinate based
			return false;
		}
		/**
		 *  @private
		 */
		//Get all the children of this component
		public function numGenieAutomationChildren():int
		{
			return uiComponent.numChildren;
		}
		
		public function getGenieAutomationChildAt(index:int):Object
		{
			if (index < uiComponent.numChildren)
			{
				var d:Object = uiComponent.getChildAt(index);
				return d;
			}   
			
			return null;
		}
		
		public function isGenieAutomationChild(child:Object):Boolean
		{
			var retValue:Boolean = false;
			try{
				if(uiComponent.getChildIndex(child) > -1)
				{
					retValue = true;
				}
				else
					retValue =  false;
			}catch(e:Error)
			{
				if(uiComponent.owns(child))
					retValue =  true;
				else
					retValue =  false;
			}
			return retValue;
		}
		
	}
}
