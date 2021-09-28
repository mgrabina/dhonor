//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Dhonor {

    event NewCampaign(string name);
    event NewRequest(uint campaignId, string description, uint value, address recipient);
    event NewDonation(uint campaignId);
    event NewVote(uint campaignId, uint requestId, uint value);
    event RequestAccepted(uint campaignId, uint requestId);

    struct SpendRequest {
        uint id;
        string description;
        uint value;
        address payable recipient;
        uint approvedValue;
        uint startTimestamp;
    }

    struct Campaign {
        uint id;
        string name;
        address manager;
        uint lockedValue;
        mapping(uint => SpendRequest) requests;
        mapping(address => uint) donors;
        uint donorsCount;
    }

    uint public minimumDonation;
    address public manager;
    mapping(address => uint) donorPoints;
    mapping(uint => Campaign) public campaigns;
    uint currentCampaignId;
    uint currentRequestId;

    constructor (){
        minimumDonation = 100000;
        manager = msg.sender;
        currentCampaignId = 1;
        currentRequestId = 1;
    }

    function createCampaign(string memory name) public {
        uint campaignId = currentCampaignId;
        Campaign storage newCampaign = campaigns[campaignId];
        newCampaign.id = campaignId;
        newCampaign.name = name;
        newCampaign.manager = msg.sender; 

        currentCampaignId++;
        emit NewCampaign(name);
    }

    function createSpendrequire(uint campaignId, string memory description, uint value, address payable recipient) public {
        require(campaigns[campaignId].manager == msg.sender);
        uint requestId = currentRequestId; 
        SpendRequest storage newSpendRequest = campaigns[campaignId].requests[requestId];
        newSpendRequest.id = requestId;
        newSpendRequest.description = description;
        newSpendRequest.value = value;
        newSpendRequest.recipient = recipient;
        newSpendRequest.startTimestamp = block.timestamp;
        
        currentRequestId++;
        emit NewRequest(campaignId, description, value, recipient);
   }

    function removeSpendrequire(uint campaignId, uint requestId) public {
        require(campaigns[campaignId].id > 0 && campaigns[campaignId].requests[requestId].id > 0);
        delete campaigns[campaignId].requests[requestId];
    }

    function donate(uint campaignId) payable public {
        require(msg.value > minimumDonation && campaigns[campaignId].id > 0);
        campaigns[campaignId].lockedValue += msg.value;
        campaigns[campaignId].donors[msg.sender] += msg.value;
        campaigns[campaignId].donorsCount++;
        emit NewDonation(campaignId);
    }

    function vote(uint campaignId, uint requestId, uint value) public {
        require(campaigns[campaignId].id > 0 
                && campaigns[campaignId].requests[requestId].id > 0 
                && campaigns[campaignId].donors[msg.sender] >= value
                && campaigns[campaignId].requests[requestId].approvedValue + value <= campaigns[campaignId].requests[requestId].value);
        campaigns[campaignId].requests[requestId].approvedValue += value;
        
        if (campaigns[campaignId].requests[requestId].value == campaigns[campaignId].requests[requestId].approvedValue) {
            approveSpent(campaignId, requestId);
        }

        emit NewVote(campaignId, requestId, value);
    }

    function approveSpent(uint campaignId, uint requestId) private {
        SpendRequest memory req = campaigns[campaignId].requests[requestId];
        req.recipient.transfer(req.value);
        delete campaigns[campaignId].requests[requestId];
        emit RequestAccepted(campaignId, requestId);
    }
}