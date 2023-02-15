// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.18;
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract MultiSig is Ownable{


event Deposit(address indexed sender,uint256 amount);
event SubmitTx(uint indexed txID);

uint256 required;
address[] public Owners;
mapping(address=>bool) isOwner;
// numrequired in wallet 
uint256 numtxrequired;
Transaction[]public transactions;
mapping(uint=>mapping(address=>bool)) public approved;
mapping(uint=>mapping(address=>bool)) public executed;

struct Transaction{
address _to;
uint _value;
bytes data;
bool executed;
}

// function modifiers
modifier NotApproved(uint256 txid){
    require(approved[txid][msg.sender]=false,"tx already approved");
    _;
}

modifier NotExecuted(uint256 txid){
    require(!transactions[txid].executed,"already executed");
    _;
}

modifier Exists(uint256 txid){
    // tx exists if index ios less than array length
    require(txid<transactions.length,"tx doesnt exist");
    _;
}


constructor( address[]memory owners,uint256 _required){
require(owners.length> 0,"Error");
require(required > 0 && required <= owners.length,"invalid length");
// check address is not 0x and doesnt repeat.
for(uint256 i=0;i<owners.length;i++){
    address owner = owners[i];
    require(owner != address(0),"0x");
    require(isOwner[owner]!= true,"Address already here");
    isOwner[owner] = true;
    Owners.push(owner);
}
required = _required;
}


function executeTransaction()external{}

function ConfirmTransaction()external{}

function SubmitTransaction(uint256 _amount,address _to,bytes calldata data) external onlyOwner{
    transactions.push(Transaction(_to,_amount,data,false));
        emit SubmitTx(transactions.length-1);
    }

function RevokeConfirmation() external {}


function ApproveTX(uint256 _txid)external onlyOwner NotExecuted(_txid) NotApproved(_txid) Exists(_txid) {

}

//balance
receive() external payable{
    emit Deposit(msg.sender,msg.value);
}
 
}