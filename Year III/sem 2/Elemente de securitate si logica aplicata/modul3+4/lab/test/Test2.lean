
/-
  Timp de lucru: 1 ora.
  La final, incarcati un fisier lean denumit `Nume_Prenume_Grupa.lean` la adresa https://www.dropbox.com/request/UagLsQbkdC6miELtFcLp
-/

section

  /-
    **Exercitiul 1: Definiti, prin recursie structurala,
    functie `sumInterval` astfel incat
    `sumInterval n m` calculeaza suma numerelor naturale din intervalul `m, ..., m + n` (inclusiv).
  -/

  def sumInterval (n : Nat) (m : Nat) : Nat := sorry

end

/-
  Demonstrati urmatoarea teorema.
-/
section
variable (p q r : Prop)
theorem ex2 : p ∧ q → q ∧ ¬¬p := sorry
end

/-
  Demonstrati urmatoarea teorema
-/
section
variable {α : Type} (p : α → Prop) (q : α → Prop)

theorem ex3 : (∀ x, p x) → (∀ x, p x ∨ q x) := sorry

end
