
/-
  # LAB 2: Propositions and proofs in Lean
-/

-- import Lab2

open Classical

/-
  `Prop` is the type of propositions.
  Examples of propositions are equalities, like the ones we've seen in Lab1.
-/
#check Prop
#check 5 = 3
#eval 5 = 3

#check 5 = 5

#check 5 = 5 ∧ 5 = 3
#check 5 = 5 ∧ 5 = 3 → False

-- rfl = reflexibility
#check (@rfl _ 5)

/-
  A proposition is itself a type. If `p : Prop`, we can speak of terms `h` of type `p`.
  We interpret some `h : p` as a *proof* of `p`, so we can say that `p` is the type of all its proofs.
  Proving a proposition `p` therefore means providing some term of type `p`.
  For instance, `rfl` from Lab1 is such term of type `x = x`, and therefore a proof that `x = x`.
  This perspective is known as *Propositions as types* or the *Curry-Howard correspondence*.
-/

section PropositionalLogic

/-
  Lean defines the usual propositional constructors: conjunction, disjunction, negation, etc.
  Each of them is governed by so-called principles of *introduction* and *elimination*.
  The introduction principle answers the question:
  *how can one, in general, prove a conjunction / disjunction / etc?*,
  while the elimination principle refers to
  *what can obtain from a conjunction / disjunction / etc?*

  Implication is not defined.
  Rather, the notions of implication and that of function coincide.
  Given `p q : Prop`, we will have another proposition `p → q : Prop`
  representing the implication from `p` to `q`, but this is simply the type of functions from `p` to `q`.
  There is no difference between the `→` used here,
  and the symbol `→` in `Int → String`, the type of functions from `Int` to `String`.
  Intuitevly, in order to prove that `p` implies `q`,
  one has to give a function that transforms proofs of `p` into proofs of `q`.
-/

/-
  Using `variable`, we can consider in this section two arbitrary propositions `p` and `q`,
  as if we said *let p and q be any propositions*.
-/

variable (p q : Prop)

/-
  ## And
  The notation `p ∧ q` is used for `And p q`.
-/
#check And
#check And p q
#print And
#check @And.intro
#check @And.left
#check @And.right

/-
  ## Or
  The notation `p ∨ q` is used ofr `Or p q`.
-/
#check Or
#check Or p q
#print Or
#check @Or.inl
#check @Or.inr
#check @Or.elim

/-
  #False
-/
#check False
#print False
#check @False.elim
/-
  Fortunately, no introduction rule for `False` exists.
  Indeed, a way of proving `False` would mean Lean is inconsistent.
-/

/-
  ## Not
  Negation is defined by `Not p := p → False`.
  `¬p`
-/
#check Not
#check Not p
#print Not

/-
  The law of excludded middle.
-/
#check em

/-
  **Exercise 1**: Prove the following theorem.
  Hint: Look at the `applyFunction` function defined in Lab1
-/
theorem modus_ponens : p → (p → q) → q := λ Hp Hpq => Hpq Hp

theorem modus_ponens' : p → (p → q) → q := by
  intro Hp Hpq
  exact Hpq Hp

theorem modus_ponens'' : p → (p → q) → q :=
  fun (hp: p) (hpq : p → q) => hpq hp

/-
  **Exercise 2**: Prove the following theorem.
  Hint: Look at the `swap` function defined in Lab1
-/
theorem and_comm : p ∧ q → q ∧ p := by
  intro Hpq
  exact And.intro (And.right Hpq) (And.left Hpq)

theorem and_comm' : p ∧ q → q ∧ p :=
  fun (Hpq: p ∧ q) => And.intro (And.right Hpq) (And.left Hpq)


/-
  In principle, any theorem can be proved by simply writing a function of the appropriate type
  (the type of the theorem's statement), like above.
  This can get unwieldy for complex proofs, so Lean offers a different embedded language called *tactic mode*.
  At any point in a proof, there is a *proof state* composed of a number of hypotheses and a number of goals needing to be proved.
  A tactic changes the proof state, until no more goals are left.
-/

theorem modus_ponens_tactics : p → (p → q) → q := by --we enter tactic mode with `by`. Note the infoview on the right.
  -- we need to prove an implication. We first suppose its premise.
  intros hp -- suppose a proof of `p` exists, and call it `hp`
            -- note the change in the proof state
  -- we still have an implication to prove, so we again assume its premise.
  intros hpq
  -- we need to prove `q`. We can obtain `q` from the conclusion of `hpq` if we provide the right premise to it
  apply hpq -- the goal would follow from `hpq` if we proved its required conclusion. Note the goal change
  -- the goal is now just one of the hypotheses
  assumption

theorem and_comm_tactics : p ∧ q → q ∧ p := by --we enter tactic mode with `by`. Note the infoview on the right.
  -- we need to prove an implication. We first suppose its premise
  intros hpq -- suppose a proof of `p wedge q` exists, and call it `hpq`
             -- note the change in the proof state
  -- we know p ∧ q, and from it can obtain both `p` and `q`
  cases hpq with | _ hp hq =>
  -- we need to prove `q ∧ p`. We know this can be proved from `And.intro`
  apply And.intro
  -- in order to apply `And.intro` we need to to have both a proof of `p` and a proof of `q`
  -- Lean produced two new goals, both of which are trivial two solve
  case left =>
    assumption
  case right =>
    assumption


/-
  Usually, tactic mode and term mode may be freely combined.
  For instance, a more concise version of the above may be:
-/
theorem and_comm_tactics' : p ∧ q → q ∧ p := by
  intros hpq
  cases hpq with | intro hp hq =>
  exact And.intro hq hp

/-
  **Exercise 3**: Prove the following theorem, using tactic mode
-/
example : p → q → (p ∧ q) :=
 by
  intro Hp Hq
  exact And.intro Hp Hq

example : p → q → (p ∧ q) := by
  intros Hp Hq
  apply And.intro
  all_goals assumption

/-
  **Exercise 4**: Give the shortest possible *term mode* proof you can think of for the above statement
-/
example : p → q → (p ∧ q) := And.intro

example : p → q → (p ∧ q) :=
fun (hp : p) (hq: q) => And.intro hp hq

/-
  **Exercise 5**: Prove the following, using tactic or term mode.
-/

/-**5.1**-/
example : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  intro Hpqr
  cases Hpqr with
    | intro Hp Hqr =>
    apply Or.elim Hqr
    case left =>
      intro Hq
      exact Or.inl (And.intro Hp Hq)
    case right =>
      intro Hr
      exact Or.inr (And.intro Hp Hr)


example : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  intro Hpqr
  cases Hpqr with | _ Hp Hqr =>
  cases Hqr
  case inl Hq =>
    apply Or.inl
    exact And.intro Hp Hq
  case inr Hr =>
    apply Or.inr
    exact And.intro Hp Hr
  done

/-**5.2**-/
example : p ∨ q → q ∨ p := by
  intro Hpq
  apply Or.elim Hpq
  case left =>
    intro Hp
    exact Or.inr Hp
  case right =>
    intro Hq
    exact Or.inl Hq

/-**5.3**-/
-- `Not p := p → False`
example : p → ¬¬p := by
-- p →  ((p → False) → False)
  intro Hp Hnotp
  exact Hnotp Hp

example : p → ¬¬p := by
-- p →  ((p → False) → False)
  intro Hp
  intro Hnp
  contradiction


/-**5.4**-/
example : (p → q) → ¬q → ¬p := by
-- (p → q) → (q → False) → (p → False)
  intro Hpq Hnotq Hp
  exact Hnotq (Hpq Hp)

/-
  After you have solved **5.4**, uncomment the following line.
-/
-- #eval remark
-- p ∨ ¬p
-- ((p → False) → False) → p
/-**5.5**-/
example : ¬¬p → p := by
  intros Hnotnotp
  have Hpem : p ∨ ¬p := Classical.em p
  cases Hpem with
    | inl Hp => exact Hp
    | inr Hnotp => exact False.elim (Hnotnotp Hnotp)


/-
  If you get stuck, uncomment the following line to get a hint for the last exercise above.
-/
#eval hint
