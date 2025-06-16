use starknet::ContractAddress;

#[starknet::interface]
pub trait IStap<TContractState> {
    fn verify_winner(ref self: TContractState, player_number: u32);
    fn set_winning_number(ref self: TContractState, winning_number: u32);
    fn get_winner_address(self: @TContractState) -> ContractAddress;
    fn get_state(self: @TContractState) -> u8;
    fn withdraw(ref self: TContractState);
}

#[starknet::contract]
pub mod Stap {
    // *************************************************************************
    //                            IMPORT
    // *************************************************************************
    use stap::constants::stap::stap_constants::StapStates;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address};


    // *************************************************************************
    //                            STORAGE
    // *************************************************************************
    #[storage]
    struct Storage {
        winner_address: ContractAddress,
        winning_number: u32,
        state: u8,
    }

    // *************************************************************************
    //                            CONSTRUCTOR
    // *************************************************************************
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.winning_number.write(0);
        self.winner_address.write(0x0.try_into().unwrap());
        self.state.write(StapStates::NOT_WINNER_SET);
    }

    #[abi(embed_v0)]
    impl StapImpl of super::IStap<ContractState> {
        fn verify_winner(ref self: ContractState, player_number: u32){
            if player_number == self.winning_number.read() {
                self.state.write(StapStates::HAS_WINNER);
            }
        }
        fn set_winning_number(ref self: ContractState, winning_number: u32) {
            let caller: ContractAddress = get_caller_address();
            let valid_address_1: ContractAddress =
                0x0388012BD4385aDf3b7afDE89774249D5179841cBaB06e9E5b4045F27B327CE8
                .try_into()
                .unwrap();
            let valid_address_2: ContractAddress =
                0x0528A7ba821024a8eC44dff0bFFe15443d811F233e4de7AB1a8C26f251597c4c
                .try_into()
                .unwrap();
            assert!(
                valid_address_1 == caller || valid_address_2 == caller,
                "You must be an owner or admin to perform this action",
            );
            self.winning_number.write(winning_number);
        }
        fn get_winner_address(self: @ContractState) -> ContractAddress {
            return self.winner_address.read();
        }
        fn get_state(self: @ContractState) -> u8 {
            return self.state.read();
        }
        fn withdraw(ref self: ContractState) {
            let caller = get_caller_address();
            assert!(self.winner_address.read() == caller, "You are not the winner");
            assert(self.state.read() == StapStates::HAS_WINNER, 'No winner yet');

        }
    }
}
