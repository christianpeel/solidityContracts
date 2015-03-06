contract Hello {
	function Hello() {
		message = "Hello World";
	}
    function getMessage() constant returns (string32) {
        return message;
    }
	string32 message;
}
