function decodeUrlParameter(uri) {

	return decodeURIComponent((uri+'').replace(/\+/g, '%20'));
}

function encodeUrlParameter(uri) {
	var encode = encodeURIComponent(uri);
	encode = encode.replaceAll('%20','+');
	encode = encode.replaceAll('~','%7E');
	encode = encode.replaceAll('!','%21');
	encode = encode.replaceAll('(','%28');
	encode = encode.replaceAll(')','%');
	encode = encode.replaceAll("'",'%27');

	return encode;
}

function setCookie(authName, username, password, expiry, expires) {
	var authname = encodeUrlParameter(authName);
	var cookie = "session=" + authname + "-user=" + username + "&";
	cookie += authname + "-pw=" + password + "&expiry=" + expiry;
	document.cookie = cookie + "; expires=" + expires +"; path=/;";
}

function getCookie(cname) {
	var name = cname + "=";
	var cookie = decodeUrlParameter(document.cookie);
	var decodedCookie = cookie.split('session=');
	var ca = decodedCookie[1].split('&');
	for	(var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') {
			c = c.substring(1);
		}
		if (c.indexOf(name) == 0) {
			return c.substring(name.length, c.length);
		}
	}

	return "";
}

function getAuthNameCookie() {
	var cookie = document.cookie;
	var decodedCookie = cookie.split('session=');
	var ca = decodedCookie[1].split('-user');
	var name = decodeUrlParameter(ca[0]);

	return name;
}

function ResetSession( t ) {
	var authname = getAuthNameCookie();
	var username = getCookie(authname + "-user");
	var password = getCookie(authname + "-pw");
	var expiry = getCookie("expiry");
//	alert(authname);
//	alert(username);
//	alert(password);
//	alert(expiry);

	var d = new Date();
//	d.setDate(1);			/* 1 - 31 */
//	d.setMonth(0);			/* 0 - 11 */
//	d.setFullYear(1970);	/* Valid Year */
//	d.setHours(0);			/* 0 - 23 */
//	d.setMinutes(0);		/* 0 - 59 */
//	d.setSeconds(0);		/* 0 - 59 */
//	d.setMilliseconds(0);	/* 0 - 999 */

	d.setUTCDate(1);		/* 1 - 31 */
	d.setUTCMonth(0);		/* 0 - 11 */
	d.setUTCFullYear(1970);	/* Valid Year */
	d.setUTCHours(0);		/* 0 - 23 */
	d.setUTCMinutes(0);		/* 0 - 59 */
	d.setUTCSeconds(0);		/* 0 - 59 */
	d.setUTCMilliseconds(0);	/* 0 - 999 */

//	d.setUTCFullYear(1970, 0, 1);
//	d.setUTCHours(0, 0, 0, 000);

	var expires = d.toUTCString();
	setCookie(authname, username, password, expiry, expires);
	setTimeout(function () {
		if (sessionStorage.getItem("session")) {
			alert(sessionStorage.getItem("session"));
		}
		sessionStorage.clear();
//		sessionStorage.removeItem('Key');
		top.location = "/login.html";
	}, t);
}

