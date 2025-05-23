// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract QuizChain {
    address public owner;

    struct Question {
        string questionText;
        string[4] options;
        uint8 correctOption; // 0-3
    }

    Question[] public questions;
    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public hasAnswered; // player => questionId => answered?

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addQuestion(
        string memory _text,
        string[4] memory _options,
        uint8 _correctOption
    ) public onlyOwner {
        require(_correctOption < 4, "Invalid correct option index");
        questions.push(Question(_text, _options, _correctOption));
    }

    function getQuestion(uint _id) public view returns (
        string memory, string[4] memory
    ) {
        require(_id < questions.length, "Invalid question id");
        Question storage q = questions[_id];
        return (q.questionText, q.options);
    }

    function answer(uint _id, uint8 _option) public {
        require(_id < questions.length, "Invalid question id");
        require(!hasAnswered[msg.sender][_id], "Already answered");
        require(_option < 4, "Invalid option");

        hasAnswered[msg.sender][_id] = true;

        if (_option == questions[_id].correctOption) {
            scores[msg.sender] += 1;
        }
    }

    function getScore(address player) public view returns (uint) {
        return scores[player];
    }

    function totalQuestions() public view returns (uint) {
        return questions.length;
    }
}
