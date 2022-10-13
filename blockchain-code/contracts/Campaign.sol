// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// Many users going to arrive on the website= and they are going to start their new campaign. But our contract 'Campaign' can be called only once,
//so solve that problem we have to call 'Campaign' contract inside another contract.

contract CampaignFactory {
    //Array, where all deployed campaigns will be pushed.
    address[] public deployedCampaigns;

    event campaignCreated(
        string title,
        uint256 requiredAmount,
        address indexed owner,
        address campaignAddress, //address on which contract is deployed
        string imgURI,
        uint256 indexed timestamp,
        string indexed category
    );

    function createCampaign(
        string memory campaignTitle,
        uint256 requiredCampaignAmount,
        string memory imgURI,
        string memory stroyURI,
        string memory category
    ) public {
        Campaign newCampaign = new Campaign(
            campaignTitle,
            requiredCampaignAmount,
            imgURI,
            stroyURI
        );
        deployedCampaigns.push(address(newCampaign));
        emit campaignCreated(
            campaignTitle,
            requiredCampaignAmount,
            msg.sender,
            address(newCampaign),
            imgURI,
            block.timestamp,
            category
        );
    }
}

contract Campaign {
    string public title;
    uint256 public requiredAmount;
    string public image; //* IPFS
    string public story; //* IPFS
    address payable public owner;
    uint256 public receivedAmount;

    event Donated(
        address indexed donor,
        uint256 indexed amount,
        uint256 indexed timestamp
    );

    constructor(
        string memory _title,
        uint256 _requiredAmount,
        string memory _imageURI,
        string memory _storyURI
    ) {
        title = _title;
        requiredAmount = _requiredAmount;
        image = _imageURI;
        story = _storyURI;
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(requiredAmount > receivedAmount, "Required amount fulfilled");
        owner.transfer(msg.value);
        receivedAmount += (msg.value); // If some people try to send together
        emit Donated(msg.sender, msg.value, block.timestamp);
    }
}
