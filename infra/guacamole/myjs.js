function CheckIE() {
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		window.location.assign('ieinfopage.html');
}
