import Std.Data.HashSet

namespace Lean

abbrev HashSet := Std.HashSet

@[inline] def mkHashSet {α : Type u} [BEq α] [Hashable α] (capacity := 8) : HashSet α :=
  Std.HashSet.emptyWithCapacity capacity

namespace HashSet

@[inline] def empty {α : Type u} [BEq α] [Hashable α] : HashSet α :=
  mkHashSet

@[inline] def numBuckets {α : Type u} [BEq α] [Hashable α] (s : HashSet α) : Nat :=
  Std.HashSet.Internal.numBuckets s

@[inline] def sdiff {α : Type u} [BEq α] [Hashable α]
    (l : HashSet α) (r : HashSet α) : HashSet (α × Bool) :=
  let out :=
    l.fold (fun acc a => if r.contains a then acc else acc.insert (a, true)) (mkHashSet)
  r.fold (fun acc a => if l.contains a then acc else acc.insert (a, false)) out

end HashSet
end Lean
