package webkul.opencart_flutter.mobikul

import android.content.Context
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import android.os.Build

class CustomWebView(context: Context, messenger: BinaryMessenger, id: Int, args: Map<String, Any>?) : PlatformView {
    private val webView: WebView = WebView(context)
    private val channel: MethodChannel = MethodChannel(messenger, "custom_webview_$id")

    init {
        val url = args?.get("url") as? String

        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        
        // Enable Autofill
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            webView.importantForAutofill = View.IMPORTANT_FOR_AUTOFILL_YES
            webView.setAutofillHints(
                View.AUTOFILL_HINT_EMAIL_ADDRESS,
                View.AUTOFILL_HINT_PASSWORD,
                View.AUTOFILL_HINT_USERNAME,
                View.AUTOFILL_HINT_CREDIT_CARD_NUMBER,
                View.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DATE,
                View.AUTOFILL_HINT_CREDIT_CARD_SECURITY_CODE
            )
        }
        
        // Enable Cookies
        val cookieManager = android.webkit.CookieManager.getInstance()
        cookieManager.setAcceptCookie(true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.setAcceptThirdPartyCookies(webView, true)
        }

        webView.settings.savePassword = true
        webView.settings.saveFormData = true
        webView.settings.databaseEnabled = true

        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                url?.let {
                    channel.invokeMethod("onPageFinished", it)
                    injectAutocompleteAttributes()
                }
            }
        }

        url?.let {
            webView.loadUrl(it)
        }
    }

    private fun injectAutocompleteAttributes() {
        val js = """
            document.querySelectorAll('input[type=password]').forEach(i=>{
              const current = i.getAttribute('autocomplete');
              if (!current || current === 'off') {
                  i.setAttribute('autocomplete','current-password');
              }
            });
            document.querySelectorAll('input[type=email]').forEach(i=>{
              const current = i.getAttribute('autocomplete');
              if (!current || current === 'off') {
                  i.setAttribute('autocomplete','username');
              }
            });
            // Also try to tag username fields that might use type='text'
             document.querySelectorAll('input[name*="user"], input[name*="login"], input[name*="email"]').forEach(i=>{
               if(i.type === 'text') {
                  const current = i.getAttribute('autocomplete');
                  if (!current || current === 'off') {
                      i.setAttribute('autocomplete','username');
                  }
               }
            });
        """
        webView.evaluateJavascript(js, null)
    }

    override fun getView(): View = webView

    override fun dispose() {
        // Cleanup if necessary
    }
}
