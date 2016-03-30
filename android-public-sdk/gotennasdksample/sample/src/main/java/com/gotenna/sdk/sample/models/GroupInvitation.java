package com.gotenna.sdk.sample.models;

/**
 * Created on 2/19/16
 *
 * @author ThomasColligan
 */
public class GroupInvitation
{
    // ================================================================================
    // Class Properties
    // ================================================================================

    private Contact contact;
    private GroupInvitationState groupInvitationState;

    public enum GroupInvitationState
    {
        SENDING,
        RECEIVED,
        NOT_RECEIVED
    }

    // ================================================================================
    // Constructor
    // ================================================================================

    public GroupInvitation(Contact contact, GroupInvitationState groupInvitationState)
    {
        this.contact = contact;
        this.groupInvitationState = groupInvitationState;
    }

    // ================================================================================
    // Class Instance Methods
    // ================================================================================

    public Contact getContact()
    {
        return contact;
    }

    public void setGroupInvitationState(GroupInvitationState groupInvitationState)
    {
        this.groupInvitationState = groupInvitationState;
    }

    public GroupInvitationState getGroupInvitationState()
    {
        return groupInvitationState;
    }
}
