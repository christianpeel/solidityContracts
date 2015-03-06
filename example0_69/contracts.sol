contract Contract {
	function Contract() {
		x = 69;
	}
	function getx() constant returns (uint r){
		return x;
	}
	uint x;
}
