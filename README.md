# 🌟 Child Sponsorship NFT Smart Contract

> **Transforming child sponsorship through blockchain transparency** 🚀

A revolutionary smart contract that brings transparency and accountability to child sponsorship programs through NFTs and on-chain payment tracking.

## 🎯 Problem & Solution

**Problem**: Traditional child sponsorship programs lack transparency, and donors rarely see measurable outcomes from their contributions.

**Solution**: 
- 🎫 Sponsors receive NFTs linked to specific children's education and well-being records
- 💰 Long-term support payments managed via secure Clarity smart contract logic
- 📊 Real-time updates and verified progress shared with sponsors on-chain
- 🔍 Complete transparency in fund allocation and milestone achievements

## ✨ Key Features

### 🏠 For Program Administrators
- **Child Registration**: Register children with detailed profiles (name, age, location, education level)
- **Milestone Tracking**: Add and verify educational/developmental milestones
- **Payment Management**: Set monthly payment amounts and manage program settings

### 💝 For Sponsors
- **NFT Sponsorship**: Receive unique NFTs representing sponsorship relationships
- **Monthly Payments**: Make secure STX payments directly to sponsored children
- **Progress Tracking**: View verified milestones and payment history on-chain
- **Full Transparency**: Access complete records of fund allocation and impact

### 📈 Impact Metrics
- Real-time tracking of total funds raised
- Verified milestone completions
- Payment history and frequency analytics
- Sponsor engagement metrics

## 🛠️ Technical Specifications

- **Blockchain**: Stacks (Bitcoin Layer 2)
- **Language**: Clarity
- **Token Standard**: Non-Fungible Token (NFT)
- **Payment Currency**: STX (Stacks)
- **Default Monthly Payment**: 1 STX (1,000,000 microSTX)

## 📋 Contract Functions

### Public Functions

| Function | Description | Access |
|----------|-------------|--------|
| `register-child` | Register a new child in the system | Owner Only |
| `sponsor-child` | Sponsor a child and mint NFT | Public |
| `make-payment` | Make monthly payment for sponsored child | NFT Owner |
| `add-milestone` | Add milestone for a child | Owner Only |
| `verify-milestone` | Mark milestone as completed and verified | Owner Only |
| `transfer` | Transfer sponsorship NFT | NFT Owner |
| `set-monthly-payment` | Update monthly payment amount | Owner Only |
| `deactivate-child` | Deactivate a child profile | Owner Only |

### Read-Only Functions

| Function | Description |
|----------|-------------|
| `get-child-profile` | Get child's complete profile |
| `get-sponsorship-record` | Get sponsorship details by token ID |
| `get-milestone` | Get specific milestone information |
| `get-payment-history` | Get payment record details |
| `get-monthly-payment-amount` | Get current monthly payment amount |
| `get-contract-balance` | Get total contract balance |
| `get-milestone-count` | Get total milestones for a child |
| `get-payment-count` | Get total payments made by sponsor |

## 🚀 Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Stacks wallet with STX tokens
- Basic understanding of Clarity smart contracts

### Installation

1. Clone this repository
```bash
git clone https://github.com/your-username/child-sponsorship-nft
cd child-sponsorship-nft
```

2. Check contract syntax
```bash
clarinet check
```

3. Run tests (if available)
```bash
npm install
npm test
```

### Usage Examples

#### 1. Register a Child (Admin Only)
```clarity
(contract-call? .Child-Sponsorship-NFT- register-child 
  "Maria Santos" 
  u8 
  "São Paulo, Brazil" 
  "Primary School")
```

#### 2. Sponsor a Child
```clarity
(contract-call? .Child-Sponsorship-NFT- sponsor-child u1)
```

#### 3. Make Monthly Payment
```clarity
(contract-call? .Child-Sponsorship-NFT- make-payment u1)
```

#### 4. Add Milestone (Admin Only)
```clarity
(contract-call? .Child-Sponsorship-NFT- add-milestone 
  u1 
  "Completed Grade 2" 
  "Successfully passed all Grade 2 subjects with good marks")
```

#### 5. Verify Milestone (Admin Only)
```clarity
(contract-call? .Child-Sponsorship-NFT- verify-milestone u1 u1)
```

## 💡 Use Cases

### 🏫 Educational Sponsorship
- Track school enrollment and attendance
- Monitor academic progress and achievements
- Fund school supplies and tuition fees

### 🏥 Healthcare Support
- Document medical checkups and treatments
- Track vaccination records
- Fund healthcare expenses

### 🎨 Skill Development
- Monitor participation in vocational training
- Track completion of skill development programs
- Fund equipment and training materials

## 🔒 Security Features

- **Owner-only Functions**: Critical operations restricted to contract owner
- **NFT Ownership Validation**: Payment functions require NFT ownership
- **Input Validation**: All user inputs are validated before processing
- **Balance Checks**: Ensures sufficient funds before processing payments
- **State Consistency**: Maintains consistent state across all operations

## 🌍 Social Impact

- **Transparency**: 100% transparent fund allocation and usage
- **Accountability**: Verifiable progress tracking and milestone completion
- **Efficiency**: Reduced administrative overhead through automation
- **Global Reach**: Borderless sponsorship opportunities
- **Trust Building**: Increased donor confidence through blockchain verification

## 📊 Data Structures

### Child Profile
```clarity
{
  name: (string-ascii 50),
  age: uint,
  location: (string-ascii 100),
  education-level: (string-ascii 50),
  sponsor: (optional principal),
  sponsorship-start: (optional uint),
  total-received: uint,
  active: bool
}
```

### Milestone Record
```clarity
{
  title: (string-ascii 100),
  description: (string-ascii 500),
  completion-date: (optional uint),
  verified: bool,
  verifier: (optional principal)
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on the Stacks blockchain for Bitcoin-secured smart contracts
- Inspired by the need for transparency in philanthropic organizations
- Dedicated to improving the lives of children worldwide

---

**Together, we can build a more transparent and impactful future for child sponsorship! 🌟**

# Child Sponsorship NFT 

