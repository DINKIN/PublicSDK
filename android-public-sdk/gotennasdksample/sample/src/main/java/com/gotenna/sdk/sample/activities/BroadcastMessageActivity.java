package com.gotenna.sdk.sample.activities;

import android.os.Bundle;
import android.view.View;

import com.gotenna.sdk.gids.GIDManager;
import com.gotenna.sdk.sample.R;
import com.gotenna.sdk.sample.models.Message;

public class BroadcastMessageActivity extends MessageActivity
{
    // ================================================================================
    // Life-cycle Methods
    // ================================================================================

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_broadcast_message);

        // A broadcast cannot be encrypted since it is sent to everyone
        // who is listening on the broadcast channel
        willEncryptMessages = false;
        willDisplayMessageStatus = false;
    }

    // ================================================================================
    // Button Click Methods
    // ================================================================================

    public void onSendMessageButtonClicked(View v)
    {
        attemptToSendBroadcastMessage();
    }

    // ================================================================================
    // IncomingMessageListener Implementation
    // ================================================================================

    @Override
    public void onIncomingMessage(Message incomingMessage)
    {
        // Only display messages sent to the broadcasts/shouts channel
        if (incomingMessage.getReceiverGID() == GIDManager.SHOUT_GID)
        {
            messagesList.add(incomingMessage);
            updateMessagingUI();
        }
    }
}
