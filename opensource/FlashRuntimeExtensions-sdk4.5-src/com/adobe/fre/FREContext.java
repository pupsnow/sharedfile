package com.adobe.fre;

import android.app.Activity;
import android.content.res.Resources.NotFoundException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

public abstract class FREContext
{
  private long m_objectPointer;

  private native void registerFunction(long paramLong, String paramString, FREFunction paramFREFunction);

  private native void registerFunctionCount(long paramLong, int paramInt);

  public abstract Map<String, FREFunction> getFunctions();

  public native FREObject getActionScriptData()
    throws FREWrongThreadException, IllegalStateException;

  public native void setActionScriptData(FREObject paramFREObject)
    throws FREWrongThreadException, IllegalArgumentException, IllegalStateException;

  public abstract void dispose();

  public native Activity getActivity()
    throws IllegalStateException;

  public native int getResourceId(String paramString)
    throws IllegalArgumentException, Resources.NotFoundException, IllegalStateException;

  public native void dispatchStatusEventAsync(String paramString1, String paramString2)
    throws IllegalArgumentException, IllegalStateException;

  protected void VisitFunctions(long clientID)
  {
    Map m = getFunctions();
    registerFunctionCount(clientID, m.size());
    Iterator it = m.entrySet().iterator();
    while (it.hasNext())
    {
      Map.Entry e = (Map.Entry)it.next();
      registerFunction(clientID, (String)e.getKey(), (FREFunction)e.getValue());
    }
  }
}