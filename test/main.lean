import Leaff.Diff
import Lean

open Lean

#eval do
  let sp ← searchPathRef.get
  summarizeDiffImports #[`Batteries.Classes.RatCast] #[`Batteries.Data.Rat] sp sp
-- #eval summarizeDiffImports #[`Mathlib] #[`Mathlib] sp₁ sp₂

#eval do
  let sp ← searchPathRef.get
  summarizeDiffImports #[`test.TestA] #[`test2.Test] sp sp
