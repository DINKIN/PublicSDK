package com.gotenna.sdk.sample.models;

/**
 * A simple model class that represent a goTenna contact.
 *
 * Created on 2/10/16
 *
 * @author ThomasColligan
 */
public class Contact
{
    // ================================================================================
    // Class Properties
    // ================================================================================

    private String name;
    private long gid;

    // ================================================================================
    // Constructor
    // ================================================================================

    public Contact(String name, long gid)
    {
        this.name = name;
        this.gid = gid;
    }

    // ================================================================================
    // Class Instance Methods
    // ================================================================================

    public String getName()
    {
        return name;
    }

    public long getGid()
    {
        return gid;
    }
}
