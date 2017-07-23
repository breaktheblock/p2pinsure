# P2P insure
Mutuals were orginally set up by communities of people with shared interests to protect each other. Mutuals allow peer-to-peer cooperative insurance. Currently creating a mutual insurance is hard for groups who have no/little access to insurance markets or believe they can self insure more efficently. We want to enable people to be able to create thier own peer-to-peer insurance policies and we are going to use the blockchain to do it.

## Potential use cases

- People where traditional insurance gives them a higher risk profile than they feel should have: For example highend sports cars owners who get higher insurance premiums but who are more likely to be safer drivers because they are obessed with thier cars
- People in developing countries with micro-businesses where traditional insurance compaines do not cover thier risks: For example a village self insuring each other for 
- Insuring things which insurance companies struggle to value but the community can: for example niche pottery collections

## Why block chain

- Naturally decentralised
- Trustless - Don't need to trust a central authority (unless you pick an adjudicator)
- Process efficency: Payments are automated and claims process (guarantee of playments)
- Low cost of running: No need for servers, databases

# What are the issues

- Claims handling: We plan to resolve this by giving people a choice on how to do it
- Premium pricing: we initially use a fixed premium but based off claims data we adjust the premium. This can be coded into the smart contract. 
- Depletion of pool: We plan to resolve it by 50% of the premiums of a pool going to a central pool which can be used to cover any losses when the pool

## What we've built

We plan to build a front end demostrating the process of setting up a policy
p2pinsure.sol - This is our contract that represents a created peer-to-peer insurance policy:
   - Create - Creates the policy
   - The policy can then be joined (by invite only or open to everyone)
   - Claims can be made via blockchain
   - Claims can be resolved one of three ways decided when the policy was created
      - Voting 
      - Independent Adjudicator
      - Automatically through an oracle

