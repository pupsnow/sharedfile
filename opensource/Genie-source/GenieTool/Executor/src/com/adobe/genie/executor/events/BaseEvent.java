//========================================================================================
//Copyright © 2012, Adobe Systems Incorporated
//All rights reserved.
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//•	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//•	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
//	documentation and/or other materials provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//========================================================================================
package com.adobe.genie.executor.events;

import java.util.ArrayList;

/**
 * This is base event class to hold event properties
 * 
 */
public class BaseEvent {

	public boolean altKey = false;
	public boolean ctrlKey = false;
	public boolean shiftKey = false;
	public String mouseX = ""; 
	public String mouseY = "";
	public ArrayList<String> arguments = new ArrayList<String>();
	public ArrayList<String> preloadArguments = new ArrayList<String>();
	
	public static final String CLICK_EVENT = "Click";
	public static final String CLICKATLOCATION_EVENT = "ClickAtLocation"; 
	public static final String DOUBLE_CLICK_EVENT = "DoubleClick";
	public static final String DOUBLE_CLICKATLOCATION_EVENT = "DoubleClickAtLocation";
	public static final String PERFORM_KEYACTION = "performKeyAction";
	public static final String DRAG_START_EVENT = "DragStart";
	public static final String DRAG_DROP_EVENT = "DragDrop";
	public static final String ITEM_CLICK_EVENT = "ItemClick";
	public static final String CONTEXTMENU_ITEM_SELECT = "menuItemSelect";
	public static final String MENU_SHOW_EVENT = "Show";
	public static final String MENU_SHOW_INDEX = "ShowIndex";
	public static final String MENU_HIDE_EVENT = "Hide";
	public static final String SELECT_EVENT = "Select";
	public static final String SELECT_INDEX_EVENT = "SelectIndex";
	public static final String OPEN_EVENT = "Open";
	public static final String CLOSE_EVENT = "Close";
	public static final String SCROLL_EVENT = "Scroll";
	public static final String INPUT_EVENT = "Input";
	public static final String TYPE_EVENT = "Type";
	public static final String SELECT_TEXT_EVENT = "SelectText";
	public static final String CHANGE_EVENT = "Change";
	public static final String CHANGE_INDEX_EVENT = "ChangeIndex";
	public static final String MOUSE_SCROLL_EVENT = "MouseScroll";
	public static final String HEADER_CLICK = "HeaderClick";
	public static final String HEADER_SHIFT = "HeaderShift";
	public static final String COLUMN_STRETCH = "ColumnStretch";
	public static final String DIVIDER_RELEASE = "Released";
	public static final String MUTE_CHANGE = "MuteChange";
	
	public static final String PLAYBACK = "playback";
	public static final String GETVALUEOF = "getValueOf";
	public static final String GETVALUEOFOBJECT = "getValueOfObject";
	public static final String GETVALUEOFDISPLAYOBJECT = "getValueOfDisplayObjects";
	
	public static final String GETPARENT = "getParent";
	public static final String GETCHILD = "getChild";
	public static final String FINDCOMPONENT = "findComponent";
	public static final String FINDCOMPONENTINDICT = "findComponentInDictionary";
	public static final String GETCELLVALUE = "getCellValue";
	public static final String GETADGCELLVALUE = "getADGCellValue";
	public static final String GETROWVALUE = "getRowValue";
	public static final String GETCOLUMNPROPERTY = "getDGColumnProperty";
	public static final String GETADGROWVALUE = "getADGRowValue";
	public static final String GETROWCOUNT = "getRowCount";
	public static final String GETCOLUMNCOUNT = "getDGColumnCount";
	public static final String GETADGROWCOUNT = "getADGRowCount";
	
	public static final String GETSDGCELLVALUE = "getSDGCellValue";
	public static final String GETSDGROWVALUE = "getSDGRowValue";
	public static final String GETSDGCOLUMNCOUNT = "getSDGColumnCount";
	public static final String GETSDGROWCOUNT = "getSDGRowCount";
	public static final String GETCOLUMHEADERVALUE = "getColumnHeaderValue";
	
	public static final String GETAXISLABELS = "getAxisLabels";
	
	public static final String GET_APP_XML = "getAppXML";
	public static final String GETLISTITEMS = "getListItems";
	public static final String GETITEMSCOUNT = "getItemsCount";
	public static final String GETMENUITEMSCOUNT = "getMenuItemsCount";
	public static final String GETMENUITEMSLABEL = "getMenuItemsLabel";
	public static final String GETCOMBOBOXITEMS = "getComboBoxItems";
	public static final String GETNUMAUTOMATABLECHILDREN = "getNumAutomatableChildren";
	public static final String GETTREEIMMEDIATECHILDREN = "getTreeImmediateChildren";
	public static final String ATTACH_EVENT_LISTENER = "attachEventListener";
	public static final String GETCHILDAT = "getChildAt";
	public static final String GETPOPUPSTATUS = "getPopUpStatus";
	public static final String CHECKFOCUS = "getFocusStatus";
	
	public static final String CAPTURE_COMPONENT_IMAGE = "captureComponentImage";
	public static final String CAPTURE_APPLICATION_IMAGE = "captureApplicationImage";
	public static final String SAVE_COMPONENT_XML = "saveComponentXML";
	
	//Touch Event Constants
	public static final String TOUCH_TAP = "TOUCH_TAP";
	public static final String TOUCH_DOUBLETAP = "TOUCH_DOUBLETAP";
	public static final String TOUCH_AND_HOLD = "TOUCH_AND_HOLD";
	public static final String HOLD_AND_DRAG = "TOUCHHOLD_AND_DRAG";
	public static final String ONE_FINGER_DRAG = "ONE_FINGER_DRAG";
	public static final String TWO_FINGER_DRAG = "TWO_FINGER_DRAG";
	public static final String THREE_FINGER_DRAG = "THREE_FINGER_DRAG";
	public static final String FOUR_FINGER_DRAG = "FOUR_FINGER_DRAG";
	public static final String FIVE_FINGER_DRAG = "FIVE_FINGER_DRAG";
	
	public static final String GESTURE_SWIPE = "gestureSwipe";
	public static final String GESTURE_ZOOM = "gestureZoom";
	public static final String GESTURE_ROTATE = "gestureRotate";
	public static final String GESTURE_PAN = "gesturePan";
}
