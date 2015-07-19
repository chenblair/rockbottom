package mycompany.rockbottom;

import android.support.v7.app.ActionBarActivity;
import android.os.*;
import android.view.*;
import android.widget.*;
import java.net.*;
import java.io.*;
import java.lang.*;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.*;
import android.content.Intent;
import org.apache.http.client.methods.*;


public class ReadStory extends ActionBarActivity {

    private float x1,x2;
    static String storyText;
    //boolean hasRun=false;
    static final int MIN_DISTANCE = 150;
    int arraySize;
    public TextView display;
    String[] ids;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.story_display);
        display=(TextView)findViewById(R.id.textDisplay);
        try {
            for (;;) {
                if (storyText == null) {
                    display.setText("Loading...");
                } else {
                    JSONObject jObject = new JSONObject(storyText);
                    //JSONArray jArray = jObject.getJSONArray("ids");
                    JSONArray jArray =jObject.getJSONArray("ids");
                    arraySize=jArray.length();
                    for(int i=0; i<jArray.length(); i++){
                        ids[i]=jArray.getString(i);
                    }
                    break;
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

    }
    public static void sendGetRequest() {

        class SendPostReqAsyncTask extends AsyncTask<String, Void, String>{

            @Override
            protected String doInBackground(String... params) {

                String website="http://rockbottom.ml:8888/story/"+MainActivity.uuid+"/related";
                BufferedReader in;

                HttpClient httpClient = new DefaultHttpClient();

                // In a POST request, we don't pass the values in the URL.
                //Therefore we use only the web page URL as the parameter of the HttpPost argument
                HttpGet request = new HttpGet(website);

                // Because we are not passing values over the URL, we should have a mechanism to pass the values that can be
                //uniquely separate by the other end.
                //To achieve that we use BasicNameValuePair
                //Things we need to pass with the POST request

                try {
                    // UrlEncodedFormEntity is an entity composed of a list of url-encoded pairs.
                    //This is typically useful while sending an HTTP POST request.
                    //UrlEncodedFormEntity urlEncodedFormEntity = new UrlEncodedFormEntity(nameValuePairList);

                    try {
                        HttpResponse response = httpClient.execute(request);
                        in = new BufferedReader(new InputStreamReader(
                                response.getEntity().getContent()));

                        // According to the JAVA API, InputStream constructor do nothing.
                        //So we can't initialize InputStream although it is not an interface
                        //InputStream inputStream = httpResponse.getEntity().getContent();

                        //InputStreamReader inputStreamReader = new InputStreamReader(inputStream);

                        //BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                        StringBuilder stringBuilder = new StringBuilder();


                        String bufferedStrChunk = null;
                        while((bufferedStrChunk = in.readLine()) != null){
                            stringBuilder.append(bufferedStrChunk);
                        }
                        storyText=stringBuilder.toString();
                        return stringBuilder.toString();

                    } catch (ClientProtocolException cpe) {
                        System.out.println("First Exception caz of HttpResponese :" + cpe);
                        cpe.printStackTrace();
                    } catch (IOException ioe) {
                        System.out.println("Second Exception caz of HttpResponse :" + ioe);
                        ioe.printStackTrace();
                    }

                } catch (Exception e) {
                    System.out.println("An Exception given because of UrlEncodedFormEntity argument :" + e);
                    e.printStackTrace();
                }

                return null;
            }

            @Override
            protected void onPostExecute(String result) {
                super.onPostExecute(result);

                if(result.equals("working")){
                    //Toast.makeText(getApplicationContext(), "HTTP POST is working...", Toast.LENGTH_LONG).show();
                }else{
                    //Toast.makeText(getApplicationContext(), "Invalid POST req...", Toast.LENGTH_LONG).show();
                }
            }
        }

        SendPostReqAsyncTask sendPostReqAsyncTask = new SendPostReqAsyncTask();
        sendPostReqAsyncTask.execute();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event)
    {
        switch(event.getAction())
        {
            case MotionEvent.ACTION_DOWN:
                x1 = event.getX();
                break;
            case MotionEvent.ACTION_UP:
                x2 = event.getX();
                float deltaX = x2 - x1;

                if (Math.abs(deltaX) > MIN_DISTANCE)
                {
                    // Left to Right swipe action
                    if (x2 > x1)
                    {
                        Toast.makeText(this, "Left to Right swipe [Next]", Toast.LENGTH_SHORT).show ();
                    }

                    // Right to left swipe action
                    else
                    {
                        Toast.makeText(this, "Right to Left swipe [Previous]", Toast.LENGTH_SHORT).show ();
                    }

                }
                else
                {
                    // consider as something else - a screen tap for example
                }
                break;
        }
        return super.onTouchEvent(event);
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
