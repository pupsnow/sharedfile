package com.adobe.fre;

public class FREObject
{
  private long m_objectPointer;

  private native void FREObjectFromInt(int paramInt)
    throws FREWrongThreadException;

  private native void FREObjectFromDouble(double paramDouble)
    throws FREWrongThreadException;

  private native void FREObjectFromBoolean(boolean paramBoolean)
    throws FREWrongThreadException;

  private native void FREObjectFromString(String paramString)
    throws FREWrongThreadException;

  private native void FREObjectFromClass(String paramString, FREObject[] paramArrayOfFREObject)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException;

  protected FREObject(CFREObjectWrapper obj)
  {
    this.m_objectPointer = CFREObjectWrapper.access$000(obj);
  }

  protected FREObject(int value)
    throws FREWrongThreadException
  {
    FREObjectFromInt(value);
  }

  protected FREObject(double value) throws FREWrongThreadException
  {
    FREObjectFromDouble(value);
  }

  protected FREObject(boolean value) throws FREWrongThreadException
  {
    FREObjectFromBoolean(value);
  }

  protected FREObject(String value) throws FREWrongThreadException
  {
    FREObjectFromString(value);
  }

  public static FREObject newObject(int value)
    throws FREWrongThreadException
  {
    return new FREObject(value);
  }

  public static FREObject newObject(double value) throws FREWrongThreadException
  {
    return new FREObject(value);
  }

  public static FREObject newObject(boolean value) throws FREWrongThreadException
  {
    return new FREObject(value);
  }

  public static FREObject newObject(String value) throws FREWrongThreadException
  {
    return new FREObject(value);
  }

  public static native FREObject newObject(String paramString, FREObject[] paramArrayOfFREObject)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

  public native int getAsInt()
    throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

  public native double getAsDouble()
    throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

  public native boolean getAsBool()
    throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

  public native String getAsString()
    throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

  public FREObject(String className, FREObject[] constructorArgs)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException
  {
    FREObjectFromClass(className, constructorArgs);
  }

  public native FREObject getProperty(String paramString)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

  public native void setProperty(String paramString, FREObject paramFREObject)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREReadOnlyException, FREWrongThreadException, IllegalStateException;

  public native FREObject callMethod(String paramString, FREObject[] paramArrayOfFREObject)
    throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

  protected static class CFREObjectWrapper
  {
    private long m_objectPointer;

    private CFREObjectWrapper(long obj)
    {
      this.m_objectPointer = obj;
    }
  }
}