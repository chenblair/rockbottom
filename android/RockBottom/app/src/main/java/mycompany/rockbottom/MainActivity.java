package mycompany.rockbottom;

import android.support.v7.app.ActionBarActivity;
import android.os.*;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
import android.content.*;
import android.util.*;
import java.net.*;
import java.io.*;
import java.lang.*;
import android.content.Intent;
import org.apache.http.client.*;
import org.apache.http.impl.client.*;
import org.apache.http.client.methods.*;
import org.apache.http.message.*;
import org.apache.http.*;
import java.util.*;
import org.apache.http.client.entity.*;
import android.telephony.*;



public class MainActivity extends ActionBarActivity {

    public static String storyText;
    public static String storyText2;
    public static int rating;
    public static String uuid;

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
    private void sendPostRequest(String givenUsername, String givenPassword,String rate) {

        class SendPostReqAsyncTask extends AsyncTask<String, Void, String>{

            @Override
            protected String doInBackground(String... params) {

                String paramUsername = params[0];
                String paramPassword = params[1];
                String rate=params[2];
                String website="http://rockbottom.ml:8888/story/new";
                BufferedReader in;

                HttpClient httpClient = new DefaultHttpClient();

                // In a POST request, we don't pass the values in the URL.
                //Therefore we use only the web page URL as the parameter of the HttpPost argument
                HttpPost httpPost = new HttpPost(website);
                //HttpGet request = new HttpGet(website);

                // Because we are not passing values over the URL, we should have a mechanism to pass the values that can be
                //uniquely separate by the other end.
                //To achieve that we use BasicNameValuePair
                //Things we need to pass with the POST request
                BasicNameValuePair usernameBasicNameValuePair = new BasicNameValuePair("userid", paramUsername);
                BasicNameValuePair passwordBasicNameValuePAir = new BasicNameValuePair("body", paramPassword);
                BasicNameValuePair rating = new BasicNameValuePair("rating", rate);

                // We add the content that we want to pass with the POST request to as name-value pairs
                //Now we put those sending details to an ArrayList with type safe of NameValuePair
                List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
                nameValuePairList.add(usernameBasicNameValuePair);
                nameValuePairList.add(passwordBasicNameValuePAir);
                nameValuePairList.add(rating);

                try {
                    // UrlEncodedFormEntity is an entity composed of a list of url-encoded pairs.
                    //This is typically useful while sending an HTTP POST request.
                    UrlEncodedFormEntity urlEncodedFormEntity = new UrlEncodedFormEntity(nameValuePairList);

                    // setEntity() hands the entity (here it is urlEncodedFormEntity) to the request.
                    httpPost.setEntity(urlEncodedFormEntity);

                    try {
                        //HttpResponse response = httpClient.execute(request);
                        //in = new BufferedReader(new InputStreamReader(
                        //        response.getEntity().getContent()));

                        // HttpResponse is an interface just like HttpPost.
                        //Therefore we can't initialize them
                        HttpResponse httpResponse = httpClient.execute(httpPost);

                        // According to the JAVA API, InputStream constructor do nothing.
                        //So we can't initialize InputStream although it is not an interface
                        InputStream inputStream = httpResponse.getEntity().getContent();

                        InputStreamReader inputStreamReader = new InputStreamReader(inputStream);

                        BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                        StringBuilder stringBuilder = new StringBuilder();

                        String bufferedStrChunk = null;

                        while((bufferedStrChunk = bufferedReader.readLine()) != null){
                            stringBuilder.append(bufferedStrChunk);
                        }
                        storyText2=stringBuilder.toString();
                        return stringBuilder.toString();

                    } catch (ClientProtocolException cpe) {
                        System.out.println("First Exception caz of HttpResponese :" + cpe);
                        cpe.printStackTrace();
                    } catch (IOException ioe) {
                        System.out.println("Second Exception caz of HttpResponse :" + ioe);
                        ioe.printStackTrace();
                    }

                } catch (UnsupportedEncodingException uee) {
                    System.out.println("An Exception given because of UrlEncodedFormEntity argument :" + uee);
                    uee.printStackTrace();
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
        sendPostReqAsyncTask.execute(givenUsername, givenPassword,rate);
    }
    public void ReadStory(View view)
    {
        TelephonyManager tManager = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
        uuid = tManager.getDeviceId();
        //new SendHttpRequestTask().execute()
        RatingBar bar;
        EditText story;
        story = (EditText)findViewById(R.id.story);
        bar = (RatingBar)findViewById(R.id.ratingBar1);
        storyText= story.getText().toString();
        rating=(int)bar.getRating();
        this.sendPostRequest(uuid,storyText,Integer.toString(rating));
        ReadStory.sendGetRequest();
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
