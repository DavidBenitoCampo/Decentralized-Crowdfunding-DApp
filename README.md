# 🚀 Decentralized Crowdfunding DApp

A fully functional decentralized crowdfunding application built on Ethereum, featuring smart contract development, automated testing, and a modern React frontend.

![Solidity](https://img.shields.io/badge/Solidity-0.8.20-363636?logo=solidity&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-14-black?logo=next.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?logo=typescript&logoColor=white)
![Ethereum](https://img.shields.io/badge/Ethereum-Sepolia-3C3C3D?logo=ethereum&logoColor=white)
![Hardhat](https://img.shields.io/badge/Hardhat-2.22-yellow?logo=hardhat&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Smart Contracts](#-smart-contracts)
- [Getting Started](#-getting-started)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Live Demo](#-live-demo)

---

## 🎯 Overview

A learning project exploring **blockchain development** by implementing a trustless crowdfunding mechanism where:

- Users can **contribute ETH** to a shared funding pool
- Funds are **automatically released** to a recipient when a threshold is met
- Contributors can **safely withdraw** their funds if the goal isn't reached
- All logic is enforced **on-chain** - no centralized authority required

> 💡 **Key Achievement**: Completed as part of the [SpeedRunEthereum](https://speedrunethereum.com) challenge series, demonstrating practical smart contract development skills.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Trustless Contributions** | Users contribute ETH with full transparency on the blockchain |
| **Automatic Threshold Detection** | Smart contract automatically determines success/failure at deadline |
| **Safe Withdrawals** | CEI pattern implementation prevents reentrancy attacks |
| **Deadline Management** | Time-based execution with on-chain timestamp validation |
| **Event Logging** | Real-time contribution tracking via blockchain events |
| **Gas Optimized** | Custom errors instead of revert strings for lower gas costs |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend (Next.js)                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Crowdfund   │  │ Contributions│  │ Debug Contracts    │  │
│  │ Dashboard   │  │ History      │  │ Interface          │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                  Wagmi + RainbowKit                         │
│              (Web3 Provider & Wallet Connection)            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Ethereum Network (Sepolia)                 │
│  ┌─────────────────────┐      ┌──────────────────────────┐  │
│  │    CrowdFund.sol    │─────▶│  FundingRecipient.sol    │  │
│  │                     │      │                          │  │
│  │ • contribute()      │      │ • complete()             │  │
│  │ • withdraw()        │      │ • completed (state)      │  │
│  │ • execute()         │      │                          │  │
│  │ • timeLeft()        │      │                          │  │
│  └─────────────────────┘      └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠 Tech Stack

### Blockchain
- **Solidity 0.8.20** - Smart contract development
- **Hardhat** - Development environment, testing, deployment
- **OpenZeppelin** - Security best practices reference

### Frontend
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type-safe development
- **Wagmi v2** - React hooks for Ethereum
- **RainbowKit** - Wallet connection UI
- **Viem** - TypeScript interface for Ethereum

### DevOps
- **Docker** - Containerized development environment
- **Vercel** - Frontend deployment
- **Etherscan** - Contract verification
- **Git/GitHub** - Version control

---

## 📜 Smart Contracts

### CrowdFund.sol

The main contract implementing the crowdfunding logic:

```solidity
/// Key Functions
function contribute() public payable notCompleted    // Accept contributions
function withdraw() public notCompleted              // Refund if threshold not met
function execute() public notCompleted               // Finalize the crowdfund
function timeLeft() public view returns (uint256)    // Time until deadline

/// Security Features
- Custom errors for gas optimization
- CEI (Checks-Effects-Interactions) pattern
- Modifier-based access control
- Reentrancy protection via state updates before transfers
```

### FundingRecipient.sol

Receives funds when the crowdfunding goal is successfully met.

---

## 🚀 Getting Started

### Prerequisites

**Option 1: Docker (Recommended)**
- Docker & Docker Compose

**Option 2: Local Setup**
- Node.js >= v20.18.3
- Yarn (v1 or v2+)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/challenge-crowdfunding.git
cd challenge-crowdfunding

# Install dependencies
yarn install
```

### Local Development

```bash
# Terminal 1: Start local blockchain
yarn chain

# Terminal 2: Deploy contracts
yarn deploy

# Terminal 3: Start frontend
yarn start
```

Open [http://localhost:3000](http://localhost:3000) to view the application.

### 🐳 Docker Development

Run the entire stack with a single command:

```bash
# Start all services (blockchain, deployer, frontend)
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

This starts:
- **Hardhat node** on port `8545`
- **Contract deployer** (auto-deploys after blockchain is ready)
- **Next.js frontend** on port `3000`

---

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
yarn test

# Run specific checkpoint tests
yarn test --grep "Checkpoint1"
yarn test --grep "Checkpoint2"
yarn test --grep "Checkpoint3"
```

### Test Coverage

- ✅ Contribution tracking
- ✅ Balance management
- ✅ Withdrawal mechanics
- ✅ Deadline enforcement
- ✅ Threshold detection
- ✅ Event emission

---

## 📡 Deployment

### Testnet Deployment (Sepolia)

```bash
# Generate deployer wallet
yarn generate

# Check deployer balance
yarn account

# Deploy to Sepolia
yarn deploy --network sepolia

# Verify contracts on Etherscan
yarn verify --network sepolia
```

### Frontend Deployment

```bash
# Deploy to Vercel
yarn vercel

# Production deployment
yarn vercel --prod
```

---

## 🌐 Live Demo

- **Frontend**: 
- **Contract (Sepolia Etherscan)**: https://sepolia.etherscan.io/address/0x58426Ad8091F72973e627Cb1752eBBA62E59d553

---

## 🔄 CI/CD Pipeline

This project includes automated CI/CD using GitHub Actions.

![CI](https://github.com/DavidBenitoCampo/Decentralized-Crowdfunding-DApp/actions/workflows/ci.yml/badge.svg)
![Deploy](https://github.com/DavidBenitoCampo/Decentralized-Crowdfunding-DApp/actions/workflows/deploy.yml/badge.svg)

### Workflows

| Workflow | Trigger | Description |
|----------|---------|-------------|
| **CI** | Push/PR to main | Lint, type check, test contracts, build frontend, security audit |
| **Deploy** | Push to main / Manual | Auto-deploy frontend to Vercel; manual contract deployment to Sepolia |

### Required Secrets

Configure these in GitHub → Settings → Secrets and variables → Actions:

| Secret | Description |
|--------|-------------|
| `VERCEL_TOKEN` | Vercel API token |
| `VERCEL_ORG_ID` | Vercel organization ID |
| `VERCEL_PROJECT_ID` | Vercel project ID |
| `DEPLOYER_PRIVATE_KEY` | Wallet private key for contract deployment |
| `SEPOLIA_RPC_URL` | Sepolia RPC endpoint (Alchemy/Infura) |
| `ETHERSCAN_API_KEY` | For contract verification |
| `SLACK_WEBHOOK_URL` | *(Optional)* Slack notifications |

### Manual Contract Deployment

1. Go to **Actions** → **Deploy** → **Run workflow**
2. Check "Deploy smart contracts to Sepolia"
3. Click **Run workflow**

---

## 📚 What I Learned

Through this project, I gained hands-on experience with:

- **Smart Contract Development**: Writing secure, gas-efficient Solidity code
- **Testing Strategies**: Comprehensive testing with Hardhat and Chai
- **Web3 Integration**: Connecting frontends to smart contracts using modern tooling
- **Security Patterns**: Implementing CEI pattern and custom error handling
- **Deployment Pipeline**: End-to-end deployment to testnets and Vercel
- **CI/CD**: Automated testing and deployment with GitHub Actions

---

<p align="center">
  <i>Built with ❤️ using Scaffold-ETH 2</i>
</p>