# Black hole Canister on the Internet Computer

*A black hole is a region in space with a gravitational pull so strong that nothing, not even light, can escape through it.*

Once a canister sets its only controller to a black hole, it becomes immutable and more!

## How to verify it is a black hole

First, we can read the source code in [src/blackhole.mo](https://github.com/ninegua/ic-blackhole/blob/main/src/blackhole.mo).
It is about 30 lines, so should be easy to convince ourselves it is not doing anything fishy.

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

We may introduce more functionalities with each new version, and once deployed it becomes a new black hole.
*Of course there are more than one black holes!*

### Version 0.0.0

Black hole Canister ID: [`e3mmv-5qaaa-aaaah-aadma-cai`](https://ic.rocks/principal/e3mmv-5qaaa-aaaah-aadma-cai)

This version gives one interface `canister_status` that is identical to the IC management canister.

```
service : {
  canister_status: (record {canister_id: canister_id;}) -> (canister_status);
}
```

Canisters that make the black hole their controllers will make their canister status public.
Anyone, including other canisters, can just call the black hole to find out the canister's status that otherwise remains hidden.
Information such as remaining cycles, module hash, etc. are now publicly and programmatically accessible, if the given canister has added the black hole as one of its controllers.

Why is it safe? Because the black hole canister itself is immutable, and cannot do anything to the canister it controls except revealing its status.

Setting a black hole as the sole controller of a canister will make it non-upgradable.
One can still top-up its cycles via the ledger, but no one can change its code or behavior.
By the way, this is how the black hole will maintain its cycles balance, possibly through donations.

## How to give your canister to a black hole

**WARNING: Be cautious with the steps. You might lose control to your canisters forever!**

Pick one of the black hole canister IDs published above, and run the following command (`e3mmv-5qaaa-aaaah-aadma-cai` aka version 0.0.0 is used here):

```
dfx canister --network=ic update-settings --controller [your-existing-controller-id] --controller e3mmv-5qaaa-aaaah-aadma-cai [CANISTER_ID]
```

You will need at least dfx version 0.8.4 to be able to set multiple controllers as shown above.

[dfx]: https://sdk.dfinity.org/docs/developers-guide/install-upgrade-remove.html
[ic-utils]: https://github.com/ninegua/ic-utils
