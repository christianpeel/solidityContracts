contract Rating {
    function setRating(string32 _key, uint256 _value) {
        ratings[_key] = _value;
    }
    mapping (string32 => uint256) public ratings;
}
