package com.gotenna.sdk.sample.adapters;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.TextView;

import com.gotenna.sdk.sample.R;
import com.gotenna.sdk.sample.models.GroupInvitation;

import java.util.List;

/**
 * Created on 2/19/16
 *
 * @author ThomasColligan
 */
public class GroupInvitationArrayAdapter extends ArrayAdapter<GroupInvitation>
{
    // ================================================================================
    // Class Properties
    // ================================================================================

    private static final int layoutResourceId = R.layout.cell_group_invite;
    private List<GroupInvitation> dataList;
    private ResendInviteListener resendInviteListener;

    // ================================================================================
    // Constructor
    // ================================================================================

    public GroupInvitationArrayAdapter(Context context, List<GroupInvitation> dataList, ResendInviteListener resendInviteListener)
    {
        super(context, layoutResourceId, dataList);
        this.dataList = dataList;
        this.resendInviteListener = resendInviteListener;
    }

    // ================================================================================
    // Overridden ArrayAdapter Methods
    // ================================================================================

    @Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
        View row = convertView;
        GroupInvitationCell cell = null;

        if (row == null)
        {
            LayoutInflater inflater = ((Activity) getContext()).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            cell = new GroupInvitationCell();
            cell.contactNameTextView = (TextView) row.findViewById(R.id.contactNameTextView);
            cell.inviteStatusTextView = (TextView) row.findViewById(R.id.inviteStatusTextView );
            cell.resendInviteButton = (Button) row.findViewById(R.id.resendInviteButton);

            row.setTag(cell);
        }
        else
        {
            cell = (GroupInvitationCell) row.getTag();
        }

        // Update the cell UI
        final GroupInvitation groupInvitationToDisplay = dataList.get(position);

        cell.contactNameTextView.setText(groupInvitationToDisplay.getContact().getName());

        switch (groupInvitationToDisplay.getGroupInvitationState())
        {
            case SENDING:
            {
                cell.inviteStatusTextView.setText(getContext().getString(R.string.group_invite_state_sending));
                cell.resendInviteButton.setVisibility(View.GONE);
            }
                break;

            case RECEIVED:
            {
                cell.inviteStatusTextView.setText(getContext().getString(R.string.group_invite_state_received));
                cell.resendInviteButton.setVisibility(View.VISIBLE);
            }
                break;

            case NOT_RECEIVED:
            {
                cell.inviteStatusTextView.setText(getContext().getString(R.string.group_invite_state_not_received));
                cell.resendInviteButton.setVisibility(View.VISIBLE);
            }
                break;
        }

        cell.resendInviteButton.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                if (resendInviteListener != null)
                {
                    resendInviteListener.onResendInviteButtonClicked(groupInvitationToDisplay);
                }
            }
        });

        return row;
    }

    @Override
    public int getCount()
    {
        return dataList.size();
    }

    // ================================================================================
    // GroupInvitationCell Class
    // ================================================================================

    static class GroupInvitationCell
    {
        TextView contactNameTextView;
        TextView inviteStatusTextView;
        Button resendInviteButton;
    }

    public interface ResendInviteListener
    {
        void onResendInviteButtonClicked(GroupInvitation groupInvitationClicked);
    }
}
