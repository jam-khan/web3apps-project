// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Funding {
    struct Campaign {
        address owner;                // Owner of the campaign
        string title;                 // title of the campaign
        string description;           // description for the campaign
        uint256 target;               // target to be reached by the campaign
        uint256 deadline;             // deadline of the the campaign
        uint256 amountCollected;      // amount collected so far
        string image;                 // image for the campaign
        address[] donators;           // list of donors
        uint256[] donations;          // list of donations
    }

    // mapping is created in order to utilize Campaign
    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    // we use _ in order to indicate that parameter is only
    // for the specific function, e.g. _owner

    // Returns id of the campaign
    function createCampaign(address _owner, string memory _title, string memory _description,
     uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {

        Campaign storage campaign = campaigns[numberOfCampaigns];

        // we will do a check.
        // If any require check fails, function doesn't goes forward and returns error.
        // Below will check if deadline is for future. If not, then error.
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;

     }

    // _id is for the address to be donated to.
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        // Below is executing the transaction
        // Payable will returns 2 values
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        // We check if transaction was successful using sent boolean
        // Then, we increment amountCollected.
        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // Below function will extract the donators and return for a specific campaign.
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {

        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        // Creates an empty array to store campaigns
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        // Stores campaigns
        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];    
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

}