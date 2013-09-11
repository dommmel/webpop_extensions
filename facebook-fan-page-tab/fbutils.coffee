# Check if visitor uses a mobile device or visits the site through
# facebook's iframe on the page tab

exports.on_page_tab = ->
  request.params["signed_request"]? or request.params["facebook"]?
  
exports.is_not_mobile_nor_pagetab = ->
  ua = request.user_agent.toLowerCase()
  return !(request.params["mobile"]? or exports.on_page_tab() or /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(ua) or /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(ua.substr(0, 4)))

# Contstruct the facebook page tab url           
exports.facebook_path = (options, enclosed, scope) ->
  _app_data = request.params["app_data"]
  param = if _app_data? then "&app_data=#{_app_data}" else ""
  return "#{scope.facebook_tab_url}#{param}"

# Check if user likes the facebook page
# returns null if we can't tell (e.g. user visits the mobile page)          
exports.is_fan = (options, enclosed, scope) ->
  if _pr = request.params["signed_request"]
    parse_signed_request(_pr, scope.facebook_app_secret).page.liked
  else
    return null

# A way to read Facebook's signed_request in JavaScript.
# adapted from https://github.com/diulama/js-facebook-signed-request
base64_decode = (data) ->
  b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
  o1 = undefined
  o2 = undefined
  o3 = undefined
  h1 = undefined
  h2 = undefined
  h3 = undefined
  h4 = undefined
  bits = undefined
  i = 0
  ac = 0
  dec = ""
  tmp_arr = []
  return data  unless data
  data += ""
  loop # unpack four hexets into three octets using index points in b64
    h1 = b64.indexOf(data.charAt(i++))
    h2 = b64.indexOf(data.charAt(i++))
    h3 = b64.indexOf(data.charAt(i++))
    h4 = b64.indexOf(data.charAt(i++))
    bits = h1 << 18 | h2 << 12 | h3 << 6 | h4
    o1 = bits >> 16 & 0xff
    o2 = bits >> 8 & 0xff
    o3 = bits & 0xff
    if h3 is 64
      tmp_arr[ac++] = String.fromCharCode(o1)
    else if h4 is 64
      tmp_arr[ac++] = String.fromCharCode(o1, o2)
    else
      tmp_arr[ac++] = String.fromCharCode(o1, o2, o3)
    break unless i < data.length
  dec = tmp_arr.join("")
  #dec = this.utf8_decode(dec);
  dec

parse_signed_request = (signed_request, secret) ->
  signed_request = signed_request.split(".")
  encoded_sig = signed_request[0]
  payload = signed_request[1]
  sig = base64_decode(encoded_sig)
  payload = base64_decode(payload)
  
  # Removing null character \0 from the JSON data
  payload = payload.replace(/\0/g, "")
  data = JSON.parse(payload)
  return "Unknown algorithm. Expected HMAC-SHA256"  unless data.algorithm.toUpperCase() is "HMAC-SHA256"
  data

