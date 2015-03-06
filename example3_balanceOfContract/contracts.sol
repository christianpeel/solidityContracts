contract Contract {
	function getBalance() constant returns (uint bal) {
		return address(this).balance;
	}
}