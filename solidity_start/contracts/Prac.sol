pragma solidity ^0.4.20;
contract Prac {
  address PracAdmin;

  mapping ( bytes32 => notarizedImage) notarizedImages; //look up notarizedImages by SHA256
  bytes32[] imagesByNotaryHash; //whitepage of all images

  mapping ( address => User) Users; //look up users by their ethereum address
  address[] usersByAddress; //whitepage of all users, by ethereum address

  struct notarizedImage {
    string imageURL;
    uint timestamp;
  }

  struct User {
    string handle;
    bytes32 city;
    bytes32 state;
    bytes32 country;
    bytes32[] myImages;
  }

  modifier onlyAdmin() {
    if (msg.sender != admin) throw;
    _;
  }

  function Prac() payable { //constructor function
    PracAdmin = msg.sender;
  }

  function registerNewUser(string handle, bytes32 city, bytes32 state,
    bytes32 country, bytes32[] myImages) returns (bool success) {
      address thisAddress = msg.sender;
      if (bytes(User[thisAddress].handle).length == 0 && bytes(handle.length) != 0) {
        Users[thisAddress].handle = handle;
        Users[thisAddress].city = city;
        Users[thisAddress].state = state;
        Users[thisAddress].country = country;
        usersByAddress.push(thisAddress); //adds this user to Users whitepage
        return true;
      } else {
        return false; // handle was null or user with handle exists
      }
    }

    function addImageToUser(string imageURL, bytes32 SHA256notaryHash) returns (bool success) {
      address thisAddress = msg.sender;
      if (bytes(User[thisAddress].handle).length != 0) { //making sure user has acct first
        if (bytes(imageURL).length != 0 } || SHA256notaryHash/length != 0) { //makes sure URL isn't blank
          if (bytes(notarizedImages[SHA256notaryHash].imageURL).length == 0) { //prevents sha->image conflicts
            imagesByNotaryHash.push(SHA256notaryHash); //adding image to image whitepage
          }
          notarizedImages[SHA256notaryHash].imageURL = imageURL;
          notarizedImages[SHA256notaryHash].timestamp = block.timestamp;
          Users[thisAddress].myImages.push(SHA256notaryHash)
        } else {
          return false; //url length was 0
        }
        return true; //successfully added image to user
    } else {
      return false; //no account for user
    }

    function removeUser(address userAddress) onlyAdmin return (bool success) {
      delete users[userAddress];
      return true;
    }

    function removeImage(bytes32 imageAddress) onlyAdmin return (bool success) {
      delete notarizedImage[imageAddress];
      return true;
    }

    function getUsers() constant returns (address[]) { return usersByAddress;}

    function getUser(address userAddress) constant returns (string, bytes32, bytes32, bytes32, bytes32[]){
      return (Users[userAddress].handle, Users[userAddress].city,
        Users[userAddress.state, Users[userAddress].country, Users[userAddress].myImages);
    }

    function getAllImages() constant returns (bytes32[]) { return notarizedImages; }

    function getUserImages(address userAddress) constant returns (bytes32[]) {
      return Users[userAddress].myImages;
    }

    function getImage(bytes32 SHA256notaryHash) constant returns (string, uint) {
      return (notarizedImages[SHA256notaryHash].imageURL, notarizedImages[SHA256notaryHash].timestamp);
    }
}
