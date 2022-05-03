// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.10;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// /**
// * @author TeamB - Blockgames Internship 2022
// * @title ZuriSchoolToken minting contract
// */
// contract ZuriSchoolToken is ERC20 {
//     address public chairman;
//     constructor() ERC20("ZuriSchoolToken", "ZST") {
//         chairman = msg.sender;
//    _mint(msg.sender,40*1e18);
//     }

//  mapping(address => bool) public teacher;

//     modifier onlyAccess() {

//         /// @notice check that sender is the chairman
//         require(msg.sender == chairman || teacher[msg.sender] == true, 
//         "Access granted to only the chairman or teacher");
//         _;
//     }

//     /** 
//     * @notice mints specified amount of tokens to an address.
//     * @dev callable only by owner of contract
//     */
//     function mint(address _to, uint256 _amount) public onlyAccess{
//         _mint(_to, _amount);
//     }

//     function mintToStakeholder(uint256 _amountOftoken, string calldata _role, address[] calldata _address) external  {
        
//         /// @notice loop through the list of students and upload
//         require(
//             _address.length >0,
//             "Upload array of addresses"
//         );
        
//         for (uint i = 0; i < _address.length; i++) {
//             //mint 5 tokens to students,10 tokens to teachers and 20 to directors
//             _mint(_address[i],_amountOftoken*1e18);

//         }
       
//     }
// }


/**
* @author TeamB - Blockgames Internship 2022
* @title ZuriSchoolToken minting contract
*/
pragma solidity ^0.8.10;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 contract ZuriSchoolToken is ERC20, Ownable {
    address public chairman;
    /// ------------------------------------- MAPPING ------------------------------------------ ///
    mapping(address => bool) public teacher;
    mapping(address => bool) public director;

      /// ------------------------------------- MODIFIER ------------------------------------------ ///
    /** @notice modifier to restrict who can call the function */
    modifier onlyAccess() {

        /** @notice check that sender is the chairman or teacher */
        require(msg.sender == chairman || teacher[msg.sender] == true, 
        "Access granted to only the chairman or teacher");
        _;
    }

     constructor() ERC20("ZuriSchoolToken", "ZST") {
        chairman = msg.sender;
        _mint(msg.sender,40*1e18);
    }
    
     /// ------------------------------------- FUNCTIONS ------------------------------------------ ///
    /** @dev helper function to compare strings */
    function compareStrings(string memory _str, string memory str) private pure returns (bool) {
        return keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str));
    }
    
    /** 
    * @notice mints specified amount of tokens to an address.
    * @dev only the teacher and the chairman can mint tokens
    */
    function mint(address _to, uint256 _amount) public onlyAccess{
        _mint(_to, _amount);
    }
    /** @notice mints specified amount of tokens to stakeholders. */
    function mintToStakeholder(uint256 _amountOftoken, string calldata _role, address[] calldata _address) onlyAccess external  {
        
        /** 
        * @notice upload the list of students and mint the specified amount of tokens to each address
        * @dev check that the list is not empty
        */
        require(
            _address.length >0,
            "Upload array of addresses"
        );
        
        for (uint i = 0; i < _address.length; i++) {
            
            /** @dev mint 5 tokens to students,10 tokens to teachers and 20 to directors */
            _mint(_address[i],_amountOftoken*1e18);

            if(compareStrings(_role,"teacher")) {
                teacher[_address[i]]=true; 
            } 
            else if(compareStrings(_role,"director")){
                director[_address[i]]=true;
            }  
        }       
    }
}

