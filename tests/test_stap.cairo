// ***************************************************************************************
//                              STAP TEST
// ***************************************************************************************
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, get_class_hash};
use stap::stap::{IStapDispatcher, IStapDispatcherTrait};
use starknet::ContractAddress;
use starknet::class_hash::ClassHash;

fn _setup_() -> (ContractAddress, ClassHash) {
    let contract = declare("Stap").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    let stap_class_hash = get_class_hash(contract_address);
    return (contract_address, stap_class_hash);
}

#[test]
fn test_verify_winner() {
    let (contract_address, _) = _setup_();
    let dispatcher = IStapDispatcher { contract_address };
    let win = dispatcher.verify_winner(0);
    assert(win == 10, 'User should win');
}
