use starknet::ContractAddress;

#[starknet::interface]
pub trait IStap<TContractState> {
    fn verify_winner(ref self: TContractState, player_number: u32);
    fn set_winning_number(ref self: TContractState, winning_number: u32);
    fn get_winner_address(self: @TContractState) -> ContractAddress;
    fn get_state(self: @TContractState) -> u8;
    fn withdraw(ref self: TContractState);
    fn get_current_balance(self: @TContractState) -> u256;
}

#[starknet::contract]
pub mod Stap {
    // *************************************************************************
    //                            IMPORT
    // *************************************************************************
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use stap::constants::stap::stap_constants::StapStates;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address, get_contract_address};


    // *************************************************************************
    //                            STORAGE
    // *************************************************************************
    #[storage]
    struct Storage {
        winner_address: ContractAddress,
        winning_number: u32,
        state: u8,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Withdraw: Withdraw,
        Winner: Winner,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Withdraw {
        #[key]
        pub winner_address: ContractAddress,
        pub winner_amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    pub struct Winner {
        #[key]
        pub winner_address: ContractAddress,
        pub winner_amount: u256,
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
        fn verify_winner(ref self: ContractState, player_number: u32) {
            if player_number == self.winning_number.read() {
                let caller: ContractAddress = get_caller_address();
                self.winner_address.write(caller);
                self.state.write(StapStates::HAS_WINNER);
                self
                    .emit(
                        Winner {
                            winner_address: self.get_winner_address(),
                            winner_amount: self.get_current_balance(),
                        },
                    );
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

            let winner_amount: u256 = self.get_current_balance();
            self.token_dispatcher().approve(self.get_winner_address(), winner_amount);
            self.token_dispatcher().transfer(self.get_winner_address(), winner_amount);

            assert(self.get_current_balance() == 0, 'Pending stks to withdraw');
            // Reset
            self.state.write(StapStates::NOT_WINNER_SET);
            self.winner_address.write(0x0.try_into().unwrap());
            
            self.emit(Withdraw { winner_address: self.get_winner_address(), winner_amount });
        }

        fn get_current_balance(self: @ContractState) -> u256 {
            self.token_dispatcher().balance_of(get_contract_address())
        }
    }
    // *************************************************************************
    //                            INTERNALS
    // *************************************************************************
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn token_dispatcher(self: @ContractState) -> IERC20Dispatcher {
            IERC20Dispatcher {
                contract_address: 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d
                    .try_into()
                    .unwrap(),
            }
        }
    }
}
