# STAP Smart Contracts

A smart contracts project developed with Cairo for the Starknet network, using Starknet Foundry as the development and testing framework.

## 🛠 Technologies

- **Cairo**: Programming language for smart contracts on Starknet
- **Starknet Foundry**: Development, testing, and deployment framework
- **Starknet**: Layer 2 network for Ethereum

## 📋 Prerequisites

Before getting started, make sure you have installed:

- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html)
- [Scarb](https://docs.swmansion.com/scarb/download.html) (Cairo package manager)

## 🏗 Project Structure

```
stap-smart-contracts/
├── src/
│   ├── lib.cairo
│   └── contracts/
│       └── stap.cairo
├── tests/
│   └── test_stap.cairo
├── scripts/
│   └── deploy.sh
├── Scarb.toml
├── snfoundry.toml
└── README.md
```

## 🧪 Testing

Run all tests:

```bash
snforge test
```

Run tests with verbosity:

```bash
snforge test -v
```

Run a specific test:

```bash
snforge test test_specific_name
```

## 📦 Build

Compile contracts:

```bash
scarb build
```

## 📖 Additional Resources

- [Cairo Documentation](https://cairo-lang.org/docs/)
- [Starknet Documentation](https://docs.starknet.io/)
- [Starknet Foundry Book](https://foundry-rs.github.io/starknet-foundry/)
- [Cairo by Example](https://cairo-by-example.com/)

## 📄 License

This project is licensed under the [MIT](LICENSE) license.
