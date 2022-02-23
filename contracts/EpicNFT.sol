// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract EpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Fantastic", "Epic", "Terrible", "Crazy", "Wild", "Terryfying", "Spooky"];
    string[] secondWords = ["Cupcake", "Pizza", "Milkshake", "Curry", "Chicken", "Sandwich", "Salad"];
    string[] thirdWords = ["Naruto", "Sasuke", "Dororo", "Gojo", "Eren", "Zhongli", "Xiao", "Yae"];

    constructor()  ERC721 ("YazeerTestNFT", "YAZ"){
        console.log("Epic NFT contract");
    }

    function pickFirstWord(uint256 tokenId) internal view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickSecondWord(uint256 tokenId) internal view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickThirdWord(uint256 tokenId) internal view returns(string memory){
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns(uint256){
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickFirstWord(newItemId);
        string memory second = pickSecondWord(newItemId);
        string memory third = pickThirdWord(newItemId);

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, "blah");
        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}