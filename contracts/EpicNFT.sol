// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

import {Base64} from "base64-sol/base64.sol";

contract EpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 NFTThreshold = 50;
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Fantastic",
        "Epic",
        "Terrible",
        "Crazy",
        "Wild",
        "Terryfying",
        "Spooky"
    ];
    string[] secondWords = [
        "Cupcake",
        "Pizza",
        "Milkshake",
        "Curry",
        "Chicken",
        "Sandwich",
        "Salad"
    ];
    string[] thirdWords = [
        "Naruto",
        "Sasuke",
        "Dororo",
        "Gojo",
        "Eren",
        "Zhongli",
        "Xiao",
        "Yae"
    ];

    constructor() ERC721("YazeerTestNFT", "YAZ") {
        console.log("Epic NFT contract");
    }

    function pickFirstWord(uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickSecondWord(uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickThirdWord(uint256 tokenId)
        internal
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeNFT() public {
        uint256 newItemId = _tokenIds.current();

        if (newItemId >= NFTThreshold) {
            return;
        }

        string memory first = pickFirstWord(newItemId);
        string memory second = pickSecondWord(newItemId);
        string memory third = pickThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, first, second, third, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        "{",
                        '"name": "',
                        combinedWord,
                        '",',
                        '"description": "A highly acclaimed collection of squares.",',
                        '"image" : "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"',
                        "}"
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function getTotalNFTCount() public view returns(uint256, uint256){
        uint256 currentCount = _tokenIds.current();
        return(currentCount, NFTThreshold);
    }
}
