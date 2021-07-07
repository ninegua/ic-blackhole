# Blackhole Canister on the Internet Computer

*A black hole is a region in space with a gravitational pull so strong that nothing, not even light, can escape through it.*

Once a canister sets its only controller to blackhole, it becomes immutable.

## How to verify it is a blackhole

First, we can read the source code in [src/blackhole.mo](https://github.com/ninegua/ic-blackhole/blob/main/src/blackhole.mo).
It is about 30 lines, so should be easy to convince ourselves it is not doing anything finishy.

Next, we need to make sure what is deployed on Internet Computer is compiled from this source code.
To do this, we can verify hash of Wasm binary from three sources: built by github, built locally, and what is deployed.

```
$ curl -Ls https://github.com/ninegua/ic-blackhole/releases/download/0.0.0/blackhole-opt.wasm|sha256sum
210cf941e5ca77daac314a91517483ac171264527e3d0d713b92bb95239d7de0  -

$ cat $(nix-build 2>/dev/null)/bin/blackhole-opt.wasm |sha256sum
210cf941e5ca77daac314a91517483ac171264527e3d0d713b92bb95239d7de0  -

$ make dfx.json && dfx canister --network=ic --no-wallet info $(cat canister_ids.json|jq -r '.blackhole.ic')
make: 'dfx.json' is up to date.
Controller: e3mmv-5qaaa-aaaah-aadma-cai
Module hash: 0x210cf941e5ca77daac314a91517483ac171264527e3d0d713b92bb95239d7de0
```

## Versions

We may introduce more functionalities with each new version, and once deployed it becomes a new blackholes.
*Yes of course there are more than one blackholes!*

### Version 0.0.0

Blackhole Canister ID: [`e3mmv-5qaaa-aaaah-aadma-cai`]().

This version gives one interface `canister_status` that is identitical to the IC management canister.

```
service : {
  canister_status: (record {canister_id: canister_id;}) -> (canister_status);
}
```

Canisters that make the blackhole their controllers will make their canister status public.
Anyone, including other canisters, can just call the blackhole to find out the canister status of a given canister that otherwise remain hidden.
Information such as the remaining cycles, module hash, etc. are now publicly and programmatically accessible, if the given canister has opted to add the blackhole as one of its controllers.

Setting the blackhole as its sole controller will make the canister non-upgradable.
One can still top-up its cycles through a call to the ledger, but no one can change its code.
This is how the blackhole will maintain its cycles balance, possibly through donations.

## How to give your canister to the blackhole

**WARNING: Be cautious with the steps. You'll lose control to your canisters forever!**

Well, if you decide to lose control and make your canister immutable. Simply give it to the blackhole:

```
dfx canister --network=ic update-settings --controller e3mmv-5qaaa-aaaah-aadma-cai [CANISTER_ID]
```

To set multiple controllers is a bit more involved, because [dfx] does not support it yet.
You either need to do it programmatically (making a call to the IC management canister), or you can use [ic-utils].

[dfx]: https://sdk.dfinity.org/docs/developers-guide/install-upgrade-remove.html
[ic-utils]: https://github.com/ninegua/ic-utils
