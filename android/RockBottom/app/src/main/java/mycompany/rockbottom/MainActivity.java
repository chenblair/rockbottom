package mycompany.rockbottom;

import android.support.v7.app.ActionBarActivity;
import android.os.*;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
import java.net.*;
import java.io.*;
import java.lang.*;
import android.content.Intent;


public class MainActivity extends ActionBarActivity {

    public static String storyText;
    public static int rating;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void InputStory(View view)
    {
        Intent intent = new Intent(this, InputStory.class);
        this.startActivity(intent);
    }

    public void ReadStory(View view)
    {
        RatingBar bar;
        EditText story;
        story = (EditText)findViewById(R.id.story);
        bar = (RatingBar)findViewById(R.id.ratingBar1);
        storyText=story.getText().toString();
        rating=bar.getNumStars();
        Intent intent = new Intent(this, ReadStory.class);
        this.startActivity(intent);
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
