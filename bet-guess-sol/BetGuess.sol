pragma solidity 0.4.19;

contract Game {

    address public owner = msg.sender;
    uint256 public gameTimeStart;
    uint256 public gameTimeEnd;
    bool public isGameOn = false;
    uint256 constant private SECONDS_IN_DAY = 86400;
    uint256 private pot = 0;
    uint256 private numberOfParticipants = 0;
    address private currentParticipant;
    uint256 private currentGuess;
    address[] private participants;
    mapping (address => uint256) participantsGuessMap;

    event GameOver(address indexed _winner);
    event TimeLeft(int256 indexed _timeLeft);
    event Test(uint256 indexed _pot, address indexed _address);
    event TimeTest(uint256 indexed _start, uint256 indexed _end);
    event TestIndex(address _address);

/*
    function Game() public {

    }*/

    modifier hasntPlayed() {
        require(participantsGuessMap[msg.sender] == 0);
        _;
    }

    modifier onlyBy(address _owner) {
        require(msg.sender == _owner);
        _;
    }

    modifier gameOn() {
        require(now <= gameTimeEnd);
        _;
    }

    modifier bet() {
        require(msg.value == 777);
        _;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function guess(uint256 _guess) public payable gameOn() hasntPlayed() bet() {
        pot = add(pot, msg.value);
        //participants.push(msg.sender);
        //currentParticipant = msg.sender;
        insertParticipant(msg.sender);
        numberOfParticipants += 1;
        participantsGuessMap[msg.sender] = _guess;
        //bind();
    }

    function insertParticipant(address participant) internal {
        if (numberOfParticipants < participants.length) {
            participants[numberOfParticipants] = participant;
        } else {
            participants.push(participant);
        }
    }
/*
    function guess(uint256 _guess) public {
        currentGuess = _guess;
    }*/

    function bind() internal {
        participantsGuessMap[currentParticipant] = currentGuess; 
    }

    function start() public onlyBy(owner) {
        gameTimeStart = now;
        gameTimeEnd = gameTimeStart + SECONDS_IN_DAY;
        // test log event
        TimeTest(gameTimeStart, gameTimeEnd);
    }

    function end() public onlyBy(owner) {
        findWinner();
        payout();
        clearParticipantsGuessMap();
        numberOfParticipants = 0;
    }

    function payout() internal {
        uint256 amountWinner = (pot * 9)/10;
        uint256 amountOwner = pot/10;
        pot = 0;
        currentParticipant.transfer(amountWinner);
        owner.transfer(amountOwner);
    }

    function clearParticipantsGuessMap() internal {
        for (uint256 index = 0; index < numberOfParticipants; index++) {
            participantsGuessMap[participants[index]] = 0;
        }
    }

    function findWinner() internal view {
        address winnersAddress = participants[participants.length - 1];
        uint256 winnersGuess = participantsGuessMap[winnersAddress];

        for (uint256 index = 0; index < numberOfParticipants; index++) {
            if (abs(int256(numberOfParticipants - participantsGuessMap[participants[index]])) < abs(int256(numberOfParticipants - winnersGuess))) {
                winnersAddress = participants[index];
                winnersGuess = participantsGuessMap[participants[index]];
            }
        }
        //Test(currentGuess, currentParticipant);
    }

    function timeLeft() public {
        TimeLeft(int256(gameTimeEnd - gameTimeStart));
    }

    function abs(int256 x) internal pure returns (int256) {
        if (x < 0) {
            return (-1 * x);
        }
        return x;
    }

    function destroy() public onlyBy(owner) {
        selfdestruct(owner);
    }

    function get(uint256 index) public {
        TestIndex(participants[index]);
    }
}