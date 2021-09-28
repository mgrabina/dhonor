//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Dhonor {
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

    uint minimumDonation;
    address manager;
    mapping(address => uint) donorPoints;
    mapping(uint => Campaign) campaigns;
    uint currentCampaignId;
    uint currentRequestId;

    constructor (uint minimum){
        minimumDonation = minimum;
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
    }

    function approveSpent(uint campaignId, uint requestId) private {
        SpendRequest memory req = campaigns[campaignId].requests[requestId];
        req.recipient.transfer(req.value);
        delete campaigns[campaignId].requests[requestId];
    }
}