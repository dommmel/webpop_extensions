# Webpop extension for Facebook Page Tabs

Create a facebook page tab (e.g. for sweepstakes) with mobile support and optional fangate powered with [webpop](http://www.webpop.com/) on the backend.

##Features
* Mobile-Support: Mobile users will see the website directly, non-mobile users will be redirected to the page tab
* Fan Gate: Users (on the page tab) can be presented with a "fan gate" if they are not liking your page yet

## Prerequisite: SSL
In order to be able to serve page tabs facebook requires you to support https/ssl. The only easy way to do so with webpop (that I know of) is by using [cloudflare](https://www.cloudflare.com/). You will need at leat a pro accoutn which is 20$/month per website/domain (5$ for each subsequent website).
Fot instructions on how to set up ssl with webpop see [Webpop Blog -  SSL without the Hassle](http://www.webpop.com/blog/2013/02/04/ssl-without-the-hassle).




## Setup

### Setup the facebook app
* Create a new facebook app
* In settings: Set "Page Tab URL" and "Secure Page Tab URL" to your webpop page (resp. a section where you want the page to live. You can set up the page later)

### Set the nessesary fields (Single Line Text)

* facebook_app_secret (set this to your application secret)
* facebook_tab_url (set this to the url of your page tab)


### Set up the webpop template
Use something like the following as the template of the webpop page (the one that you set as the page tab url in your facebook app's settings.)

    <pop:content>

      <pop:utils:is_not_mobile_nor_pagetab>
        <pop:redirect to="<pop:utils:facebook_path/>"/>
      </pop:utils:is_not_mobile_nor_pagetab>

      <!-- User visits the page tab -->
      <pop:utils:on_page_tab>
          
        <pop:utils:is_fan>
          <!-- user likes the page -->
          Thanks for liking us!
        </pop:utils:is_fan>

        <pop:utils:not_is_fan>
          <!-- user doen not like the page -->
          You better like us!
        </pop:utils:not_is_fan>
      
      </pop:utils:on_page_tab>

      <!-- User visits the mobile page -->
      <pop:utils:not_on_page_tab>

        <!-- user is not on the page tab but on the mobile page -->
        We don't care if you like us

      </pop:utils:not_on_page_tab>

    </pop:content>
    
### Install the webpop extension
Copy over ``fbutils.coffee`` to your extension folder 
    
### Install the tab on your facebook page
Log into facebook and visit the following page in your browser. Replace YOUR_APP_ID with your facebook app's ID (you'll need to have the fan page already set up).

[https://www.facebook.com/dialog/pagetab?app_id=YOUR_APP_ID&redirect_uri=https://facebook.com](https://www.facebook.com/dialog/pagetab?app_id=YOUR_APP_ID&redirect_uri=https://facebook.com)
