actor {
  public type canister_id = Principal;

  public type definite_canister_settings = {
    freezing_threshold : Nat;
    controllers : [Principal];
    memory_allocation : Nat;
    compute_allocation : Nat;
  };

  public type canister_status = {
     status : { #stopped; #stopping; #running };
     memory_size : Nat;
     cycles : Nat;
     settings : definite_canister_settings;
     module_hash : ?[Nat8];
     idle_cycles_burned_per_day : Nat;
  };

  public type IC = actor {
   canister_status : { canister_id : canister_id } -> async canister_status;
  };

  let ic : IC = actor("aaaaa-aa");

  public func canister_status(request : { canister_id : canister_id }) : async canister_status {
    await ic.canister_status(request)
  }
}
