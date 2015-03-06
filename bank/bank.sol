contract bank {
    // General parameters
    address owner; // Bank owner
    uint reserve; // Reserve = sum(savings)-sum(loans)
    uint reserveRatio; // Reserve ratio
    // Info about savers
    uint saveRate; // 1+interest rate per block for savings in Q0.16
    mapping (address => uint) saveBalances;
    uint prevUpdateBlock; // Block number of last update block
    // Info about borrowers
    uint loanRate; // 1+interest rate per block for loans in Q0.16
    mapping (address => uint) loanBalances;
    mapping (address => uint) loanBlock; // Block when loan to be paid
    mapping (address => uint) creditScore;

    function bank() { // Constructor
        owner = msg.sender;
		reserve = msg.value;
		saveRate = 9216; // (12.5/100+1)*8192
		loanRate = 9216; // (12.5/100+1)*8192
    }
	
    function calcInterest(uint rateP1, uint numBlocks) constant returns (uint rate) {
        uint rateT = rateP1;
		for (uint ix = 0; ix<numBlocks;ix++) {
			rateT *= rateP1/8192;
        }
        return rateT;
    }
    // Savings Deposit
//    function deposit() { // This is the right 'deposit' technique
//        reserve +=msg.value;
//        saveBalances[msg.sender] += msg.value; // balances initialized to 0
//    }
    function deposit(uint amount) { // kludgy deposit
		reserve +=amount;
        saveBalances[msg.sender] += amount; // balances initialized to 0
    }
    // Savings Withdrawal
    function withdraw(uint amount) {
		if (reserve >= amount) {
			if (saveBalances[msg.sender] >= amount) {
				msg.sender.send(amount);
                saveBalances[msg.sender] -= amount;
				reserve -= amount;
            } else { // trying to withdraw more money than balance
				// (1) return err msg somehow?
                // (2) use in credit score if multiple times?
            }
        } else { // not enough money in bank
            // (1) return err msg somehow
            // (2) queue people up for withdrawals
        }
    }

    // Get a loan
    function getLoan(uint amount, uint numBlocks) {
//		if (prevUpdateBlock < block.number) { // maybe this is always true?
//        }

		uint finalAmount = (amount*calcInterest(loanRate, numBlocks))/8192;
		if ((creditScore[msg.sender] >= finalAmount) ||	(saveBalances[msg.sender] >= finalAmount)) {
			msg.sender.send(amount);
            loanBalances[msg.sender] += finalAmount;
			reserve-=amount;
        } // maybe send an error
    }
    // Pay a loan off
    function payLoan() { // this function is close to the right
        if (loanBalances[msg.sender] <= msg.value) {
            // some logic to actually take the money from the borrower,
            // and return any over-payment
            if (loanBlock[msg.sender] == block.number) {
                creditScore[msg.sender] += loanBalances[msg.sender];
            }
            loanBalances[msg.sender] = 0;
        } 
    }
    function payLoanStupid(uint payOff) {
        if (loanBalances[msg.sender] == payOff) {
            if (loanBlock[msg.sender] == block.number) {
                creditScore[msg.sender] += loanBalances[msg.sender];
            }
            loanBalances[msg.sender] = 0;
			reserve+=payOff;
        } 
    }

    // compound savings on a regular basis. This means 
//    function compoundSavings() {
//    }

    function queryLoanBalance() constant returns (uint balance) {
        return loanBalances[msg.sender]; }
    function querySavingsBalance() constant returns (uint balance) {
        return saveBalances[msg.sender]; }
    function queryOwner() constant returns (address addr) {
        return owner; }
    function queryBankBal() constant returns (uint bal) {
		return address(this).balance; }
    function queryLoanRate() constant returns (uint rate) {
		return loanRate; }
    function queryCreditScore() constant returns (uint rate) {
		return creditScore[msg.sender]; }
    function querySaveRate() constant returns (uint rate) {
		return saveRate; }
    function queryReserve() constant returns (uint resrv) {
		return reserve; }
	
    function setSaveRate(uint rate) {
		if (msg.sender==owner) {
			saveRate=rate;
		}}
    function setLoanRate(uint rate) {
		if (msg.sender==owner) {
			loanRate=rate;
		}}
	function checkLoanFinal(uint amount, uint numBlocks) constant returns (uint retval){
        uint finalAmount = amount*calcInterest(loanRate, numBlocks);
		return finalAmount/8192;
	}
}
