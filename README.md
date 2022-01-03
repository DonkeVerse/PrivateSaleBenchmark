# Private Sale and Airdrop Benchmarks [DonkeVerse.com](donkeverse.com)

The goal of this repository is to compare the gas efficency of mappings, signatures, and merkle trees for private sales and airdrops.

Bloom filters are not viable. No matter how low one sets the probabilty for a false positive, an adversary can always mine for address that is accepted by the bloom filter.

A zk-snark or trie based data structure would be interesting to test in the future.

## Instructions to run
```shell
git clone https://github.com/DonkeVerse/PrivateSaleBenchmark.git
cd PrivateSaleBenchmark
npm install
REPORT_GAS=true npx hardhat test
```

## Results
You can change the number of addresses to allow in test/benchmark-test.js with the constant `NUMBER_OF_ADDRESSES_TO_ALLOW` on line 12.

Here is the result for 4098 addresses. _Remember, about 21,000 gas is required to initiate a transaction in Ethereum, so subtract 21,000 to get the true cost._

<pre>
·---------------------------------------------|---------------------------|--------------|-----------------------------·
|            Solc version: 0.8.10             ·  Optimizer enabled: true  ·  Runs: 1000  ·  Block limit: 30000000 gas  │
··············································|···························|··············|······························
|  Methods                                    ·               71 gwei/gas                ·       3793.37 usd/eth       │
··············|·······························|·············|·············|··············|···············|··············
|  Contract   ·  Method                       ·  Min        ·  Max        ·  Avg         ·  # calls      ·  usd (avg)  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  benchmark1Mapping            ·          -  ·          -  ·       23424  ·            1  ·       6.31  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  benchmark2PublicSignature    ·          -  ·          -  ·       29293  ·            1  ·       7.89  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  benchmark3MerkleTree         ·          -  ·          -  ·       35853  ·            1  ·       9.66  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  setAllowList1Mapping         ·          -  ·          -  ·       43928  ·            1  ·      11.83  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  setAllowList2SigningAddress  ·          -  ·          -  ·       26786  ·            1  ·       7.21  │
··············|·······························|·············|·············|··············|···············|··············
|  Benchmark  ·  setAllowList3MerkleRoot      ·          -  ·          -  ·       43911  ·            1  ·      11.83  │
··············|·······························|·············|·············|··············|···············|··············
|  Deployments                                ·                                          ·  % of limit   ·             │
··············································|·············|·············|··············|···············|··············
|  Benchmark                                  ·          -  ·          -  ·      616997  ·        2.1 %  ·     166.18  │
·---------------------------------------------|-------------|-------------|--------------|---------------|-------------·
</pre>

Note that if we refund

## Public Signature with Leading Zeros

| Public Key                                  | Gas Cost |
|---------------------------------------------|----------|
| 0x2132bC228dcAe17EE18Bbf078FA48FB12d90C015  | 29273    |
| 0x0D9A6F68f2A49DBa6e8991e64c3173088c25a566  | 29261    |
| 0x00c53Da2e09bc19c02bb56aE480eEa48081E8bF2  | 29273    |
| 0x000C6a093B079Bd237079213881Ce9DD8283c9FC  | 29281    |
| 0x00008Eb5Faf23B93c85Fa87BBA3641e3E20475C4  | 29273    |
| 0x00000e71C7532da2f6Fe9d10942f25C565E0b045  | 29273    |

More tests are needed, but there doesn't seem to be a correlation between leading zeros and gas costs. Ethereum address generated with [https://vanity-eth.tk/](https://vanity-eth.tk/).


## Merkle Tree as a Function of the Number of Addresses
The more addresses there are to airdrop to, the longer the merkle proof (logarithmically) and the more expensive Merkle Trees become. Merkle trees are only cost effective for \~32 or fewer addressses.


| Number Of Addresses | Merkle Tree Gas Cost |
|---------------------|----------------------|
| 16                  | 27862                |
| 32                  | 28732                |
| 64                  | 29636                |
| 128                 | 30517                |
| 256                 | 31389                |
| 512                 | 32284                |
| 1024                | 33195                |
| 2048                | 34036                |
| 4096                | 34906                |
| 8192                | 35801                |
| 16384               | 36746                |
