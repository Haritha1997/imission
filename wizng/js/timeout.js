// var IDLE_TIMEOUT = 20; //seconds
// var _idleSecondsCounter = 0;
// document.onclick = function() {
//   _idleSecondsCounter = 0;
// };
// document.onmousemove = function() {
//  _idleSecondsCounter = 0;
// };
// document.onkeypress = function() {
//   _idleSecondsCounter = 0;
// };
// var myInterval = window.setInterval(CheckIdleTime, 1000);
// function CheckIdleTime() {
// 	_idleSecondsCounter++;
// 	var oPanel = document.getElementById("SecondsUntilExpire");
// 	if (oPanel)
// 	   oPanel.innerHTML = (IDLE_TIMEOUT - _idleSecondsCounter) + "";
// 	if (_idleSecondsCounter >= IDLE_TIMEOUT) 
// 	{
// 	    alert("HTTP Session Timeout !! \n\n\r    Please login again...");
// 	    window.clearInterval(myInterval);
//             window.location.href = "/cgi/Nomus.cgi";
// 	    oPanel.innerHTML = ("Job Done");
// 	    // return false;
// 	}
//         // return true;
// }
var IDLE_TIMEOUT = 900; //seconds
var _idleSecondsCounter = 0;
document.onclick = function () {
	_idleSecondsCounter = 0;
};
document.onmousemove = function () {
	_idleSecondsCounter = 0;
};
document.onload = function () {
	_idleSecondsCounter = 0;
};
document.onkeypress = function () {
	_idleSecondsCounter = 0;
};

var myInterval = window.setInterval(CheckIdleTime, 1000);

function CheckIdleTime() {
	_idleSecondsCounter++;
	var oPanel = document.getElementById("SecondsUntilExpire");
	// if (oPanel)
	// oPanel.innerHTML = (IDLE_TIMEOUT - _idleSecondsCounter) + "";
	//if(_idleSecondsCounter%10 == 0)
	// alert("Time Counting!");
	if (_idleSecondsCounter >= IDLE_TIMEOUT) {
		// alert("Time expired!");
		alert("HTTP Session Timeout !! \n\n\r    Please login again...");
		window.clearInterval(myInterval);
		top.location.href = "/cgi/Nomus.cgi";
		// oPanel.innerHTML = ("Job Done");
	}
}