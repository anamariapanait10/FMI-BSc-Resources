
-- Ignore the following two lines
set_option autoImplicit false

macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)

/- *** First-order logic -/

/-
  Beyond the propositional connectives we have seen in Lab2,
  we are also provided with the first-order quantifiers, ∀ and ∃,
  enabling us to state and prove properties of objects.
-/

/- ** Universal quantifier -/
/-
  Given a type `α : Type` and a function `p : α → Prop`
  (i.e. a unary predicate on `α`), we can form the new proposition
  `∀ x : α, p a`, stating that `p` holds for all `x` in `α`.
-/
variable {α : Type} (p : α → Prop)
#check ∀ x : α, p x

/- One may omit type annotations when they are inferrable from context -/
#check ∀ x, p x

/-
  In order to prove a universal statement `∀ x : α, p x`,
  the basic strategy is to assume an aribtrary `x : α`,
  and then prove `p x` for it.
  This can be done using the `intros` tactic, just like assume the hypothesis of an implication.
-/

example : ∀ n : Nat, 0 ≤ n := by
  intros n
  exact Nat.zero_le n -- a lemma from the standard library

#check Nat.zero_add
/- Exercise 1. Hint: Use the lemma above -/
example : ∀ n : Nat, 0 + n = n := by
  intros n
  exact Nat.zero_add n

#check Nat.add_comm
/- Exercise 2. Hint: Use the lemma above -/
example : ∀ (n : Nat) (m : Nat), n + m = m + n := by
  intros n m
  exact Nat.add_comm n m

/- Exercise 3 -/
example : ∀ x : α, p x → p x := by
  intros _ h
  --exact h
  assumption

/-
  If you have a universal hypothesis `h : ∀ x : α, p x`,
  this can be instantiated to any expression `a : α`, producing
  a proof of `p x`.

  This instantiation can be done simply by function application
-/
namespace Hidden
  variable (a : α)
  #check p a


  example : (∀ x : α, p x) → p a := by
    intros h
    exact h a
  /- Or as a function -/
  example : (∀ x : α, p x) → p a := fun h => h a


  /- Alternatively, the `specialize` tactic can be used to replace a universal hypothesis
    with an instantiation thereof.
  -/
  example : (∀ x : α, p x) → p a := by
    intros h
    specialize h a
    assumption

end Hidden
variable (q : α → Prop)

example : (∀ x : α, p x) ∧ (∀ x, q x) → (∀ x : α, p x ∧ q x) := by
  intros h
  intros a
  cases h with
  | intro hp hq =>
  specialize hp a
  specialize hq a
  exact And.intro hp hq

/- Exercise 4 -/
example : (∀ x : α, p x ∧ q x) → (∀ x : α, p x) ∧ (∀ x, q x) := by
  intros h
  apply And.intro
  case left =>
    intros a
    specialize h a
    exact And.left h
  case right =>
    intros a
    specialize h a
    exact And.right h


/- Exercise 5 -/
example : (∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x) := by
  intros h1 h2 a
  specialize h1 a
  specialize h2 a
  exact h1 h2

/- ** Existential quantifier -/

/-
  Given a type `α` and a predicate on `p : α → Prop` on `α`,
  we can construct the proposition `∃ x : α, p x`,
  stating that there exists an `x` in `α` such that `p x` holds.
-/
#check ∃ x : α, p x
#print Exists

/- Proving an existential statement `∃ x : α, p x`
  involves providing a `w : α` (called a witness) and proving that `p` holds for `w`.

  You can do this with the `use` tactic, which accepts a term (claimed to be a witness)
  and then asks you to prove that it is indeed a witness.
-/
#check @Exists.intro
#check Nat.add_zero
example (m : Nat) : ∃ n : Nat, m + n = m := by
  use 0
  exact Nat.add_zero m -- a lemma from the standard library

namespace Ex3
variable (p q : Nat → Prop)

/- Exercise 6 -/
example : (∀ x : Nat, p x) → (∃ x : Nat, p x) := by
  intros h
  use 17
  specialize h 17
  exact h

/- Exercise 7 -/
example : (∀ x : Nat, p x) → (∃ x : Nat, p x) ∨ (∃ x : Nat, q x) := by
  intros h
  apply Or.inl
  use 42
  specialize h 42
  exact h

/- Exercise 8 -/
example : ∀ x : Nat, ∃ y : Nat, x = y := by
  intros x
  use x
  rfl

/-
  If you have an existential hypothesis `h : ∃ x : α, p x`,
  you can use `cases h with | intro w hw` to split `h` into a witness `w` and a proof `hw` that `w`
  satisfies `p`.
-/

namespace Ex2
  variable (p q : α → Prop)

  example : (∃ x : α, p x) → ¬(∀ x, ¬ p x) := by
    intros h
    intros h'  -- ¬ r := r → False
    cases h with
    | intro w hw =>
    specialize h' w
    contradiction

  /- Exercise 9 -/
  example : (∃ x : α, p x ∨ q x) → (∃ x : α, p x) ∨ (∃ x : α, q x) := by
    intros h
    cases h with
    | intro w hw =>
      cases hw with
      | inl hp => apply Or.inl
                  use w
                  exact hp
      | inr hq => apply Or.inr
                  use w
                  exact hq

  /- Exercise 10 -/
  example : (∃ x : α, p x) ∨ (∃ x : α, q x) → (∃ x : α, p x ∨ q x) := by
    intros h
    apply Or.elim h
    case left =>
      intro h1
      cases h1 with
      | intro w hw =>
        apply Exists.intro w
        apply Or.inl
        exact hw
    case right =>
      intro h2
      cases h2 with
      | intro w hw =>
        apply Exists.intro w
        apply Or.inr
        exact hw
end Ex2
end Ex3

variable {β : Type} (r : α → β → Prop)
/- Exercise 11 -/
example : (∃ x : α, ∀ y : β, r x y) → (∀ y : β, ∃ x : α, r x y) := by
  intros h
  cases h with
  | intro w hw =>
    intros a ha
    specialize hw a
    done


/- Exercise 12 -/
example : (∀ x, p x) → ¬(∃ x, ¬p x) := sorry
