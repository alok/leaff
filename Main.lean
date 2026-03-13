import «Leaff»
import Cli

open Cli

unsafe
def runDiffCmd (p : Parsed) : IO UInt32 := do
  let newModule : ModuleName   := p.positionalArg! "newModule" |>.as! ModuleName
  let oldModule : ModuleName   :=
    if p.hasFlag "oldModule" then p.flag! "oldModule" |>.as! ModuleName
    else p.positionalArg! "newModule" |>.as! ModuleName
  -- IO.println <| "newModule: " ++ toString newModule
  -- IO.println <| "oldModule: " ++ toString oldModule

  let newSearchPath := p.positionalArg! "newSearchPath" |>.as! (Array String)
  -- IO.println <| toString <| newSearchPath
  let oldSearchPath := p.positionalArg! "oldSearchPath" |>.as! (Array String)
  -- IO.println <| toString <| oldSearchPath

  summarizeDiffImports
    #[{ module := oldModule, isExported := false }]
    #[{ module := newModule, isExported := false }]
    (oldSearchPath.toList.map Coe.coe)
    (newSearchPath.toList.map Coe.coe)
  return 0

unsafe
def diffCmd : Cmd := `[Cli|
  leaff VIA runDiffCmd; ["0.0.1"]
  "Print the diff between two Lean environments."

  FLAGS: -- TODO copy some from actual diff / gitdiff e.g short, ignore certain diffs etc
    verbose;                    "Declares a flag `--verbose`. This is the description of the flag. Does nothing currently"
    oldModule : ModuleName;     "Optional: The name of the old module to diff against. This can reference Lean modules like `Init.Data.Array` or Lean files using a relative path like `Init/Data/Array.lean`. In most use cases this will be the same as `newModule`, and does not need to be set."

  ARGS:
    -- TODO consider how to include multiple old / new modules
    newModule     : ModuleName; "The name of the new module to diff against. This can reference Lean modules like `Init.Data.Array` or Lean files using a relative path like `Init/Data/Array.lean`. In most usage this will simply be a single top level module name, for example `Mathlib`."
    oldSearchPath : Array String; "The search path for the old version of the module. This should be a comma-separated list of relative paths, for example `\"./lake-packages/Cli/build/lib\",\"./lake-packages/std/build/lib\",\"./build/lib\"`, as in the `oleanPath` printed by `lake print-paths`."
    newSearchPath : Array String; "The search path for the new verison of the module, as previous"

  -- The EXTENSIONS section denotes features that
  -- were added as an external extension to the library.
  -- `./Cli/Extensions.lean` provides some commonly useful examples.
  EXTENSIONS:
    author "alexjbest"
]

unsafe
def main (args : List String) : IO UInt32 :=
  diffCmd.validate args
