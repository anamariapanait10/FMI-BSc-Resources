
/-
  Timp de lucru: 1 ora.
  La final, incarcati un fisier lean denumit `Nume_Prenume_Grupa.lean` la adresa https://www.dropbox.com/request/pwPjc4Z7OS5uxbA5c63W
-/

section

  /-
    **Exercitiul 1: Definiti, prin recursie structurala,
    functia `nthSquareSum` astfel incat
    `nthSquareSum n` calculeaza sum patratelor numerelor naturale de la `0` la `n`.
  -/
  open Nat

  def nthSquareSum (n : Nat) : Nat :=
  match n with
  | zero => 0
  | succ n' => n * n + nthSquareSum n'


  #eval nthSquareSum 2
end

/-
  Demonstrati urmatoarea teorema.
-/
section
variable (p q r : Prop)
theorem ex2 : p ∧ (q ∧ r) → (p ∧ r) ∧ q := by
  intros Hpqr
  cases Hpqr with
  | intro Hp Hqr =>
    cases Hqr with
    | intro Hq Hr =>
      apply And.intro
      apply And.intro
      exact Hp
      exact Hr
      exact Hq
end

/-
  Demonstrati urmatoarea teorema.
-/
-- ¬¬p e p -> False -> False
section
variable {α : Type} (p : α → Prop)
theorem ex3 : (∀ x, p x) → (∀ x, (¬¬p x)) := by
  intros Hp a Hnp
  apply Hnp
  apply Hp a

end
