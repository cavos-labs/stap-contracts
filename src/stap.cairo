#[starknet::interface]
pub trait IStap<TContractState> {
    fn verify_winner(self: @TContractState, player_number: u32) -> u32;
}

#[starknet::contract]
pub mod Stap {
    // *************************************************************************
    //                            IMPORT
    // *************************************************************************
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    // *************************************************************************
    //                            STORAGE
    // *************************************************************************
    #[storage]
    struct Storage {
        winning_number: u32,
    }

    // *************************************************************************
    //                            CONSTRUCTOR
    // *************************************************************************
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.winning_number.write(0);
    }

    #[abi(embed_v0)]
    impl StapImpl of super::IStap<ContractState> {
        fn verify_winner(self: @ContractState, player_number: u32) -> u32 {
            if player_number == self.winning_number.read() {
                //let half_winner_amount: u32 = (self.balance.read() * 50) / 100;
                let half_winner_amount: u32 = 10;
                // Pay us and pay winner.
                return half_winner_amount;
            }
            let not_winner: u32 = 0;
            return not_winner;
        }
    }
}
