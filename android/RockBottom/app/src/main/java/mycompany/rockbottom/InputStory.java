package mycompany.rockbottom;

import android.support.v7.app.ActionBarActivity;
import android.os.*;
import android.view.*;
import android.view.inputmethod.*;
import android.widget.*;
import java.net.*;
import java.io.*;
import java.lang.*;
import android.content.*;



public class InputStory extends ActionBarActivity {

    private static EditText story;
    private static Button submit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        submit = (Button)findViewById(R.id.Submit);
        story = (EditText)findViewById(R.id.story);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
