contract myContract {
	event incremented(uint total);
	function Contract() {
		total = 0;
	}
	function getTotal() constant returns (uint r){
		return total;
	}
	function incr() {
		total= total+1;
		incremented(total);
	}
	uint total;
}