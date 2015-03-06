contract hasOwner {
	function hasOwner() {
		ownr = msg.sender;
	}
	address ownr;
}
