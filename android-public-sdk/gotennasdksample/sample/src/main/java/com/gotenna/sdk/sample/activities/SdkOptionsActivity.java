package com.gotenna.sdk.sample.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.gotenna.sdk.interfaces.GTErrorListener;
import com.gotenna.sdk.bluetooth.GTConnectionManager;
import com.gotenna.sdk.commands.GTCommand.GTCommandResponseListener;
import com.gotenna.sdk.commands.GTCommandCenter;
import com.gotenna.sdk.commands.GTError;
import com.gotenna.sdk.responses.GTResponse;
import com.gotenna.sdk.responses.SystemInfoResponseData;
import com.gotenna.sdk.sample.R;
import com.gotenna.sdk.sample.models.FirmwareUpdateHelper;
import com.gotenna.sdk.user.UserDataStore;

public class SdkOptionsActivity extends AppCompatActivity
{
    // ================================================================================
    // Class Properties
    // ================================================================================

    private FirmwareUpdateHelper firmwareUpdateHelper;

    // ================================================================================
    // Life-Cycle Methods
    // ================================================================================

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sdk_options);

        // This person has not selected their user or set their GID yet
        // Force them to the SetGidActivity screen so they can select a user
        if (UserDataStore.getInstance().getCurrentUser() == null)
        {
            Intent intent = new Intent(this, SetGidActivity.class);
            startActivity(intent);
        }

        // Check for that latest goTenna Firmware file from the Internet
        firmwareUpdateHelper = new FirmwareUpdateHelper(this);
        firmwareUpdateHelper.checkForNewFirmwareFile();
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        firmwareUpdateHelper = null;
    }

    // ================================================================================
    // Button Click Methods
    // ================================================================================

    public void onSendEchoButtonClicked(View v)
    {
        // Send an echo command to the goTenna to flash the LED light
        GTCommandCenter.getInstance().sendEchoCommand(new GTCommandResponseListener()
        {
            @Override
            public void onResponse(GTResponse response)
            {
                int stringResourceId = 0;

                switch (response.getResponseCode())
                {
                    case POSITIVE:
                        stringResourceId = R.string.echo_success_toast;
                        break;
                    case NEGATIVE:
                        stringResourceId = R.string.echo_nack_toast;
                        break;
                    case ERROR:
                        stringResourceId = R.string.echo_error_toast;
                        break;
                }

                Toast.makeText(getApplicationContext(), stringResourceId, Toast.LENGTH_SHORT).show();
            }
        }, new GTErrorListener()
        {
            @Override
            public void onError(GTError error)
            {
                Log.w(getClass().getSimpleName(), error.toString());
            }
        });
    }

    public void onSendGetSystemInfoButtonClicked(View v)
    {
        GTCommandCenter.getInstance().sendGetSystemInfo(new GTCommandCenter.GTSystemInfoResponseListener()
        {
            @Override
            public void onResponse(SystemInfoResponseData systemInfoResponseData)
            {
                // This is where you could retrieve info such at the goTenna's battery level and current firmware version
                Toast.makeText(getApplicationContext(), systemInfoResponseData.toString(), Toast.LENGTH_LONG).show();
            }
        }, new GTErrorListener()
        {
            @Override
            public void onError(GTError error)
            {
                Log.w(getClass().getSimpleName(), error.toString());
            }
        });
    }

    public void onSetGidButtonClicked(View v)
    {
        Intent intent = new Intent(this, SetGidActivity.class);
        startActivity(intent);
    }

    public void onSendPrivateButtonMessageClicked(View v)
    {
        Intent intent = new Intent(this, PrivateMessageActivity.class);
        startActivity(intent);
    }

    public void onSendBroadcastMessageClicked(View v)
    {
        Intent intent = new Intent(this, BroadcastMessageActivity.class);
        startActivity(intent);
    }

    public void onCreateGroupButtonClicked(View v)
    {
        Intent intent = new Intent(this, CreateGroupActivity.class);
        startActivity(intent);
    }

    public void onSendGroupMessageButtonClicked(View v)
    {
        Intent intent = new Intent(this, GroupMessageActivity.class);
        startActivity(intent);
    }

    public void onDisconnectButtonClicked(View v)
    {
        // There is another method you can use, GTConnectionManager.getInstance().disconnectWithRetry();
        // That method will disconnect us from the current goTenna and immediately start scanning for another goTenna
        // Chances are we will re-connect to the goTenna we were just connected to, but it is helpful for clearing up
        // potential connection issues or performing other business logic.
        GTConnectionManager.getInstance().disconnect();

        Intent intent = new Intent(this, PairingActivity.class);
        startActivity(intent);

        finish();
    }

    public void onUpdateFirmwareButtonClicked(View v)
    {
        // For a firmware update, first we ask the goTenna what its current firmware version is so we can check if an update is needed
        GTCommandCenter.getInstance().sendGetSystemInfo(new GTCommandCenter.GTSystemInfoResponseListener()
        {
            @Override
            public void onResponse(SystemInfoResponseData systemInfoResponseData)
            {
                if (firmwareUpdateHelper.shouldDoFirmwareUpdate(systemInfoResponseData))
                {
                    firmwareUpdateHelper.showFirmwareUpdateDialog(systemInfoResponseData);
                }
                else
                {
                    Toast.makeText(getApplicationContext(), R.string.firmware_is_already_updated_toast_text, Toast.LENGTH_SHORT).show();
                }
            }
        }, new GTErrorListener()
        {
            @Override
            public void onError(GTError error)
            {
                Log.w(getClass().getSimpleName(), error.toString());
            }
        });
    }
}
